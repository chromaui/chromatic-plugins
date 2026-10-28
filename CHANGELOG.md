# Changelog

All notable changes to the Chromatic plugins. Versions follow semver; the
version in `.claude-plugin/plugin.json` is the one installed users see.

## 0.5.7

### Patch Changes

- 275af51: The plugin has an icon, and links to Chromatic's documentation, support, privacy policy and terms of service, for plugin directory listings.

## 0.5.6

### Patch Changes

- The hooks now check the commit in the repository the agent is working in, which Claude Code names in each hook's input. In a worktree session, such as one the Claude desktop app starts, the background watcher used to read the main checkout's commit, so it woke the agent within seconds about the wrong build and never about the one just pushed.

## 0.5.5

### Patch Changes

- The session start hook passes the `chromatic.config.json` path to your agent only when it is a plain path, so a folder name in a cloned repository cannot add text to the agent's instructions.

## 0.5.4

### Patch Changes

- The query skills give the Chromatic MCP's new answer limit of 100,000 characters.

## 0.5.3

### Patch Changes

- `query-chromatic` no longer says a capture's rendered DOM, its trace or interaction test failures are missing from the API.

## 0.5.2

### Patch Changes

- `fix-broken-stories` and `query-chromatic` read a capture's `links` for the error report, the rendered DOM and the Playwright trace, in place of the deprecated `errorsJsonUrl`.

## 0.5.1

### Patch Changes

- When you name the tests to accept or deny, such as "accept the Button change on build 42", the agent does it instead of asking you again. A go-ahead like "ship it" still gets one question that names the tests and the build.
- Seven skills are reworded so they start on plain requests and do what they describe. `reduce-snapshot-usage` gives the link to the Manage screen, `connect-project` looks a project up when you only ask which one it is, `check-project-setup` reports UI Tests being off as a failed check, and `query-chromatic` never reads a project token.
  
  `fix-accessibility-violations` no longer stops on a build that is only waiting for review, pushes its fix on a feature branch without asking, and keeps checking until the new build finishes.

## 0.5.0

### Minor Changes

- `review-visual-changes` shows you before, after and diff pictures, groups the changes your code explains, leaves out changes still waiting on your default branch, and asks before it accepts anything.
- Your agent now checks Chromatic on its own after it pushes or opens a pull request, in a repository that has a `chromatic.config.json`. In Claude Code the plugin ships three hooks for this. Two add a note for the agent. The third waits in the background for the build and wakes the agent when it finishes, by reading Chromatic's status on the commit from GitHub with the `gh` CLI. None of them changes anything. Codex gets no hooks, so the plugin asks for no hook trust there.

### Patch Changes

- `check-merge-readiness` carries its own query, reports accessibility as "not measured" when a build has no accessibility data, and treats Chromatic's status on the pull request as the gate, not the CI job.

## 0.4.1

### Patch Changes

- Link straight to a project's Manage screen and quarantine dashboard, and use each quarantined story's issue rate to judge whether it can come back.

## 0.4.0

### Minor Changes

- Find the project id from the repository's git remote, so most repositories connect without pasting a link.
- Accept, deny, quarantine and unquarantine tests when you ask, with the new `chromatic_mutate` tool.

## 0.3.1

### Patch Changes

- Installs copy only the plugin, not the whole repository, so they no longer carry the release tooling or install its dependencies.
- The plugin listing now describes the review, flaky story, merge readiness and API query skills, not only builds and accessibility.

## 0.3.0 - 2026-09-25

Skills for the common jobs an agent can now do with the Chromatic public
API. They need the Chromatic MCP's `chromatic_search_schema` and
`chromatic_query` tools.

### Added

- `query-chromatic` answers questions about builds, tests, snapshots,
  reviewer comments, branches and published components, starting from
  tested queries and searching the API for anything else.
- `fix-broken-stories` finds the stories a build could not capture, fixes
  the cause, and checks the fix on the next build.
- `review-visual-changes` compares each changed snapshot with the code
  change, and flags the changes the code does not explain.
- `address-review-feedback` turns reviewer comments into changes and drafts
  a reply for each thread.
- `run-build` runs a build from this machine for just the stories being
  changed, and reports the result.
- `check-merge-readiness` says whether a branch is ready to merge from
  Chromatic's side, and lists what is left if not.
- `reduce-snapshot-usage` shows where a project's snapshots go, and proposes
  story changes that use fewer without losing coverage.
- `triage-flaky-stories` finds quarantined and unstable stories, and fixes
  what makes them render differently from run to run.
- `find-existing-component` checks the repository and the published
  Storybook for a component before an agent builds a new one.
- `check-project-setup` checks that the repository is connected to the
  right project, and that the project is set up to test it.

### Changed

- `get-latest-build` explains each build status and what to do next.

## 0.2.2 - 2026-09-23

### Changed

- `fix-accessibility-violations` reads accepted violations, which the
  Chromatic MCP now returns. An empty diff now means no violations, and only
  a missing result means unknown. A story marked
  `ACCEPTED` was already signed off, so the agent asks before fixing it. A
  fix is confirmed from the story's diff on the next build, not by the story
  leaving the roll-up, which also lists improvements.

## 0.2.1 - 2026-09-21

### Changed

- The skills refer to each other by name ("the `connect-project` skill") and
  no longer by `/chromatic:connect-project`. That spelling is Claude Code's;
  Codex invokes the same skill as `$connect-project`, and both agents read
  the same file.

## 0.2.0 - 2026-09-10

### Added

- `/chromatic:connect-project`: finds the repository's Chromatic project id,
  or asks the user for a project link and writes `chromatic.config.json` so
  the tools stop asking. Every tool takes a `projectId`, and until now a
  repository without the file was a dead end.
- `/get-latest-build [branch]`: reports the latest build for the current
  branch. Tools are called by the agent from conversation and are never slash
  commands in either agent; skills are, so the build tool now has one named
  after it. Claude Code also lists it as `/chromatic:get-latest-build`.

### Removed

- The `connect-storybook` command. It registered the Hosted Storybook MCP,
  a different server that serves one published Storybook's component docs,
  and only Claude Code could see it. The README keeps the one-line
  `mcp add` for people who want that server.

### Changed

- The skill is `fix-accessibility-violations`, no longer
  `fixing-accessibility-violations`. Invoke it as
  `/chromatic:fix-accessibility-violations` in Claude Code and
  `$fix-accessibility-violations` in Codex.
- The skill no longer stops when `chromatic.config.json` is missing; it
  follows `/chromatic:connect-project` instead. It also no longer suggests
  `/chromatic:connect-storybook` for a missing project id, which never
  created the file.
- The manifests carry what the plugin directories render: repository,
  keywords, and a category for Claude Code; the same plus the `interface`
  block (display name, example prompts, brand color, policy links) for Codex,
  and an install policy on the Codex marketplace entry. Each skill's Codex
  manifest carries an example prompt.
- CI refuses a `commands/` directory and requires every skill to ship its
  Codex manifest, so the two agents cannot drift apart.
- The skill says an empty diff is not a clean story. Chromatic diffs only the
  rules that changed, so a story whose violations were all accepted earlier
  and did not move comes back with no rules; the skill points at the test page
  instead of calling it violation free.

## 0.1.1 - 2026-09-02

### Fixed

- Codex could not connect. A fresh `codex plugin add` read the Claude Code
  `.mcp.json`, which carried a `${CHROMATIC_MCP_URL:-...}` URL that Codex does
  not expand, so `codex mcp login` failed with "relative URL without a base".
  The server is now declared once, in `.mcp.json`, with a plain production
  URL, and both agents read it.
- The server showed up in Claude Code as `chromatic:mcp` while the README said
  to pick `chromatic`. It is now named `chromatic` everywhere.

### Changed

- The environment variable override for the endpoint is gone. The plugin
  always connects to production.
- The README now includes the `codex mcp login chromatic` step Codex needs.
- CI rejects a `.mcp.json` that contains a variable.

## 0.1.0 - 2026-09-02

First release: the marketplace manifest, the Chromatic plugin for Claude Code
and Codex, the fixing-accessibility-violations skill, and the connect-storybook
command.
