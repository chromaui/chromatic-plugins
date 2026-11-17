---
"chromatic-plugins": patch
---

Agents can now find builds from the Storybook Visual Tests addon. When the user ran a build locally, the `get-latest-build` skill asks `chromatic_get_latest_build` to include local builds with its `localBuilds` and `localBuildAuthorEmail` options. On a Chromatic server without those options, it uses the new `query-chromatic` recipe for the latest build including local builds, which asks the API directly.
