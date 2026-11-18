---
"chromatic-plugins": patch
---

Smaller models follow the skills more closely. The push hooks now count a Chromatic step in CI, not only a `chromatic.config.json`, as a sign that Chromatic tests the repository, so projects that run Chromatic only in CI still get the build check. The review skill checks how every unexplained change was captured and always ends with the reply or question that accepts the expected changes, saying in it when the verdicts are unconfirmed. Trace viewer links are URL-encoded, kept to the reply because they expire, and given beside the test's lasting link. The latest-build skill goes on to the review or the broken-story fix when the person asked for more than the status, and the merge-readiness skill runs the review when the person wants the waiting changes judged and asks before any other hand-off.
