# Test Isolation and Model Maintenance

A test can pass while changing live state. A model setting can validate while other consumers still use the retired route. This update documents the checks that distinguish those outcomes.

## Change Under Review

- **Change type:** public workflow documentation.
- **Files:** [test isolation](../../docs/self-improvement.md#check-the-isolation-contract-before-the-call) and [model-route maintenance](../../reference/model-playbook/README.md#maintain-model-routes-as-one-change).
- **Issue:** none. This scheduled update captures existing operational work.
- **Failure location:** a test calls code before checking its isolation contract; a model replacement leaves consumers or activation unchecked.

The model-playbook directory is the single mapped artifact selected for a targeted refresh. Its README gains maintenance guidance. The example roster, model files, runtime configuration, and installed skills are unchanged.

## Method and Baseline

These are eight manually reviewed documentation cases. The comparison uses saved pre-edit copies and the revised instructions. The scenarios are hypothetical; this review runs no live trial, provider request, model switch, or scheduler.

The earlier isolation section already requires disposable directories, blocked external boundaries, and rejection of an implementation that ignores an override. The addition makes the pre-call ordering and its negative controls explicit. The earlier model guide already requires configuration, registry, documentation, live checks, and validation to agree. The refresh specifies consumer coverage and separates discovery, preview, activation, and operation evidence.

## Isolation Cases

| Case | Representative task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| I1 | An old implementation ignores the fake callback. | Reject implementations that ignore overrides inside an isolation boundary. | Check the callback contract without invoking the unsafe implementation; retain lower-level blocks. |
| I2 | The isolation assertion is missing or placed after the operation. | Establish isolation before imports and execution. | Require negative controls for both omissions and late assertions; reject each before the operation starts. |
| I3 | A filtered test selection still starts a real subprocess. | Block subprocesses at the reachable boundary. | State explicitly that test selection provides no side-effect protection. |
| I4 | A clean rerun follows an earlier live-state change. | Preserve evidence and investigate a safety failure. | Keep the original failure, prevention result, and incident investigation separate; the rerun cannot erase history. |

Each revised instruction addresses the case without claiming complete isolation from a source-string match. A deliberate refactor can require an assertion update. The maintainer must review the changed boundary; this documentation does not establish a false-alarm rate.

## Model-Maintenance Cases

| Case | Representative task | Earlier guidance | Revised instruction and reviewed outcome |
| --- | --- | --- | --- |
| M1 | Discovery finds a newer provider model. | Update approved routes and evaluate them. | Keep discovery separate from activation and preserve the decision to approve the switch. |
| M2 | The replacement is also present in the fallback chain. | Keep configuration and routing defaults aligned. | Remove the self-fallback, preserve aliases and parameters, and verify unrelated settings remain unchanged. |
| M3 | A scheduled prompt or plugin setting still names a retired model. | Check active intents and human-readable guidance. | Inventory these consumers explicitly; report unreadable inputs as incomplete coverage and keep historical exceptions narrow. |
| M4 | A provider call succeeds but the runtime has not activated the change. | Run live model checks. | Determine restart needs, check service health, and verify the intended operation through the selected runtime. |

The wider switching and scanning tools are described as implementation requirements. This update does not ship them or claim that the existing public validator covers every live consumer.

## Metrics and Evaluation-Fault Review

Eight of eight manual cases have an explicit instruction and a stated limit. These are author judgments about documentation coverage, not executable behavioral tests or measured improvements in agent compliance.

The review credits existing guidance rather than treating every added detail as a previously absent rule. Passing a later test does not revise an earlier failure. A configuration preview or provider response cannot substitute for activated-runtime evidence.

## Untested Behavior

This review does not reproduce a live incident, audit historical side effects, run model-switching software, or measure future agent behavior. Source-pattern checks can miss alternate paths. Actual isolation and activation need separate executable and live evidence within the operator's authority.

## Result

**Ship the documentation.** Keep operational repairs and their acceptance independent of this public update.

## Artifact and Sign-Off

The complete manual records are I1–I4 and M1–M4 above, in `reports/evals/2026-10-31-test-isolation-and-model-maintenance.md`. The [changelog](../../CHANGELOG.md#2026-10-31) links this evaluation.

Reviewed by: Claw, GPT-6. Date: 2026-10-31. This is an author review, not an independent or cross-model review.

Lesson: verify a safety precondition before the operation it protects, and verify an activated model through the consumer that will use it.
