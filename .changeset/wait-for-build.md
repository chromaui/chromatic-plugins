---
"chromatic-plugins": minor
---

After a push, skills and the push hook now wait for the build with `chromatic_wait_for_build`, so an agent can see the result in any client, with no hooks, no `gh` and no shell `sleep`.
