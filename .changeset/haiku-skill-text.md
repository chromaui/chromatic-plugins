---
"chromatic-plugins": patch
---

Smaller models follow the skills more closely. After a push in a repository that Chromatic does not test, the hook now tells the agent to leave Chromatic out of its answer. The review skill checks how every unexplained change was captured and always ends with the reply that accepts the expected changes, the trace viewer links are written out in full rather than as a template, and the latest-build skill goes on to the review or the broken-story fix when the person asked for more than the status.
