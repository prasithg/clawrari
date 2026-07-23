# Don't Ship a Skill Without an Eval

A skill is a chunk of instructions the agent is supposed to load at the right moment and ignore the rest of the time. That "right moment" is a boundary, and boundaries drift. Someone edits the skill's description to be clearer and accidentally drops the word that made it fire. Someone adds a new skill whose trigger overlaps an old one. The skill still *reads* fine in a diff — the regression shows up only as the agent silently failing to load it, or loading it on the wrong prompt. You find out in production, from a bad answer, weeks later.

The regression suite ([regression-suite.md](regression-suite.md)) turns prose guardrails into assertions. This is the same move aimed one level up: turn "this skill triggers correctly and says the right thing" into a check that runs and fails loudly, *before* the skill ships. It is the executable end of a "no-eval = not Done" gate — a skill change isn't done until an eval covers it.

## What the eval actually locks

Two things, and they are different:

1. **The trigger boundary.** The skill must fire on prompts it owns (happy cases) and stay silent on prompts it doesn't (negative cases). Over-triggering is as much a bug as under-triggering — a skill that loads on everything is noise, and a skill that loads on nothing is dead weight. You need both sides tested, and most people only write the happy ones.
2. **The content guarantee.** When the skill *does* fire, the response has to contain the right things and avoid the wrong ones — the current SDK call, not the deprecated one; the approved pattern, not the anti-pattern. Cheap regex asserts (`present` / `absent`) cover most of this without a model judge.

## The case file

One file per skill. Each case is a prompt, a language tag, whether it *should* trigger, and the content checks to apply when it does:

```json
{
  "skill": "model-routing",
  "cases": [
    {
      "prompt": "which model should I use for a big refactor?",
      "language": "en",
      "should_trigger": true,
      "expected_checks": [
        {"kind": "present", "pattern": "effort|routing|ladder"},
        {"kind": "absent",  "pattern": "gpt-3\\.5"}
      ]
    },
    {
      "prompt": "convert this CSS to Tailwind",
      "language": "en",
      "should_trigger": false
    }
  ]
}
```

A useful minimum is **5 happy + 5 negative** prompts per skill. The negatives are where the value is — they are the prompts that look plausibly adjacent but belong to a different skill, and they are what catches an over-broad description edit.

## Four design rules that make the eval trustworthy

**1. Load the skill in isolation.** The runner reads only the skill's own definition file — never prior eval outputs, run logs, or past verdicts. An agent that can see its own previous traces can "pass" by pattern-matching its history instead of reasoning from the skill. Isolation is what makes a green result mean something.

**2. Derive the trigger signals from the *live* skill file.** Don't hardcode the trigger keywords in the eval. Extract them from the skill's current description and its "when to use" section at run time. Now the mechanism has teeth: if someone edits the description and drops a trigger term, the happy cases that relied on that term go red automatically. The eval guards the exact text that ships. Optional `extra_signals` / `anti_signals` only *sharpen* the boundary; they never replace the auto-derived set.

**3. Score outcomes, not paths.** Run each case several times (3–6 trials) and pass it on a **majority** vote. Do not assert "loaded on turn 1" or any specific internal path — models are non-deterministic and a rigid path assertion produces flaky reds that train people to ignore the suite. You care whether the boundary held across trials, not how it got there.

**4. Keep the model judge optional and lazy.** The deterministic regex asserts should require no live model call at all, so the eval runs free and fast in CI. An LLM judge for the fuzzier "is this response actually good" question is a bolt-on you load only when explicitly asked for — never a hard dependency of the base run.

## Wiring it in

The runner exits `0` when every case passes, `1` when a case fails, and a distinct code for a usage/load error. That non-zero exit is the whole point: it lets the eval gate a pre-commit hook, a CI job, or a night-work completion sweep. Adding a skill becomes a three-step contract — write the case file (happy + negative), run it green, link the artifact — and "I updated the skill" stops being a claim you take on faith.

The eval doesn't prove the skill is *good*. It proves the skill still fires where it should, stays quiet where it shouldn't, and says the non-negotiable things when it speaks. That is the floor, and shipping without it is shipping blind.
