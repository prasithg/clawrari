# Config

Use [openclaw.example.json](openclaw.example.json) as a starting point, not as a drop-in final config.

It reflects the Clawrari operating model:

- local gateway
- browser-enabled workflow
- file-first memory with optional local indexing
- multiple model providers
- plugin slots for memory and active-memory helpers
- explicit web and exec tool defaults

Before using it:

1. replace all placeholder values
2. move secrets into environment variables
3. trim providers and plugins you do not actually use
4. tighten browser allowlists for your own environment
5. test each connector manually before turning on cron jobs
