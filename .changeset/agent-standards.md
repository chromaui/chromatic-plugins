---
"chromatic-plugins": minor
---

The plugin now follows the Agent Skills and Agent Plugins 1.0.0 specifications. Skills carry only the frontmatter the Agent Skills spec defines, so `run-build` no longer sets `disable-model-invocation`: Claude Code and Cursor may now pick it, but its description limits it to explicit requests, and it runs a build only after the user says yes to the exact command shown. Codex keeps it explicit-only through its `agents/openai.yaml`. Skills name `query-chromatic` recipes by their headings instead of linking into another skill's folder, and `check-merge-readiness` offers a build rather than starting one. Cursor's manifest and MCP config moved out of the portable package to `plugins/chromatic/.cursor-plugin`, beside the Claude Code manifest, so the only client-specific files left in the package are the per-skill Codex metadata Agent Skills allows. CI now checks every skill against the Agent Skills spec.
