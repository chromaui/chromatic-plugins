---
"chromatic-plugins": minor
---

The plugin now follows the Agent Skills and Agent Plugins 1.0.0 specifications to the letter. Skills carry only the frontmatter the Agent Skills spec defines, so `run-build` no longer sets Claude Code's `disable-model-invocation`: it still runs a build only after the user says yes to the exact command, and Codex keeps it explicit-only. No skill links into another skill's folder. Cursor's manifest and MCP config moved out of the portable package to `plugins/chromatic/.cursor-plugin`, beside the Claude Code manifest, and read the package's skills from there, so the package holds nothing client-specific.
