---
"chromatic-plugins": patch
---

Skills now follow the repository's own Chromatic settings and the user's role. `run-build` reads the config file and `chromatic` script the CLI will use, shows the exact command before running it, no longer pairs a narrow scope with TurboSnap in a way the CLI refuses, warns about settings that auto-accept changes or change the exit code, and asks before building when the user's role cannot start builds. `get-latest-build` and `check-merge-readiness` no longer link skipped builds and report the last build that ran instead. The accessibility skills say accessibility tests are only available on Storybook projects instead of suggesting they be turned on.
