---
"chromatic-plugins": minor
---

The Claude Code hooks are now prompt hooks, which the Claude plugin directory accepts from any organization. After a push or a new pull request, a hook still tells the agent to check the Chromatic build. The session start reminder and the background build watcher are gone, because prompt hooks cannot run on session start or wait in the background.
