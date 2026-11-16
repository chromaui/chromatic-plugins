---
"chromatic-plugins": patch
---

After a push or a new pull request in a repository with no chromatic.config.json, the hook now tells the agent to say nothing about Chromatic, instead of leaving it to report that there is no build to check.
