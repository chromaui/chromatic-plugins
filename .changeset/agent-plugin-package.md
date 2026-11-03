---
"chromatic-plugins": minor
---

Codex now installs the plugin from `plugins/chromatic/agent-plugin`, a package in the open [Agent Plugins](https://agent-plugins.org) format that other agents can install too. It holds the skills, the MCP server and the icon, and no hooks. Claude Code reads the same skills from it and keeps its hooks beside it. Nothing changes for Claude Code users; Codex users get the new location with `codex plugin marketplace upgrade chromatic`.
