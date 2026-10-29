---
"chromatic-plugins": patch
---

`check-merge-readiness` no longer calls a fully accepted build "not ready". It used to require `testCount(reviewable: true)` to be 0, but that count includes changes that were already accepted. It now checks that no test is still pending. The branch-build recipe in `query-chromatic` counts pending tests for the same reason.
