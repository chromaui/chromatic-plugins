<div align="center">

# 🟣 Chromatic Plugins

**Chromatic for your coding agent.**

One install connects Claude Code or Codex to your Chromatic projects, so your agent can review the visual changes on your branch, fix broken stories and accessibility violations, and tell you whether the branch is ready to merge.

📚 [Documentation](https://www.chromatic.com/docs/mcp) ∙ 💬 [Support](https://www.chromatic.com/docs/support) ∙ 📝 [Changelog](CHANGELOG.md) ∙ 📄 [MIT License](LICENSE)

</div>

---

## ⚡ Install

You need a [Chromatic](https://www.chromatic.com) account with at least one project, and [Claude Code](https://code.claude.com/docs) or [Codex](https://developers.openai.com/codex).

### Claude Code

Inside a session:

```
/plugin marketplace add chromaui/chromatic-plugins
/plugin install chromatic@chromatic
```

Then run `/mcp`, choose the Chromatic server, and log in through your browser.

### Codex

From a terminal:

```
codex plugin marketplace add chromaui/chromatic-plugins
codex plugin add chromatic@chromatic
codex mcp login chromatic
```

<details>
<summary><strong>Claude Desktop and claude.ai</strong></summary>

<br/>

These add the Chromatic server as a connector. You get the tools, but not the skills, which come with the plugin.

1. Open **Customize → Connectors**, click **+**, and choose **Add custom connector**.
2. Enter `https://mcp.chromatic.com/mcp`. Leave the OAuth client ID and secret empty.
3. Click **Connect** and approve the request on chromatic.com.

On a Team or Enterprise plan, an owner adds the connector once under **Organization settings → Connectors → Add → Custom → Web**, and each person then connects with their own Chromatic login. Owners can set each tool to **Always allow**, **Needs approval** or **Blocked**. Keep `chromatic_mutate`, the tool that changes tests, on **Needs approval**.

</details>

### Check it worked

Ask your agent "what time is it on the Chromatic server?". If it answers, you are connected.

## 🧩 What you get

**The Chromatic MCP server**, at `https://mcp.chromatic.com/mcp`. Its tools read your builds, tests, accessibility results and published Storybooks, and answer other questions through the Chromatic API. One tool, `chromatic_mutate`, changes things: it accepts, denies, quarantines or unquarantines a test. Ask your agent "what Chromatic tools do you have?" for the current list.

**Skills**, which your agent uses when they fit, or when you ask for one by name:

| Skill | What it does |
| --- | --- |
| `get-latest-build` | Reports the state of your branch on Chromatic, with what to do next |
| `check-merge-readiness` | Says whether your branch is ready to merge from Chromatic's side, and what is left if not |
| `review-visual-changes` | Shows a build's visual changes as before, after and diff pictures, and accepts or denies them when you ask |
| `fix-broken-stories` | Finds the stories a build could not capture, fixes the cause, and checks the next build |
| `fix-accessibility-violations` | Fixes the accessibility violations a build reported, and checks the next build |
| `address-review-feedback` | Turns reviewer comments on a build into changes and draft replies |
| `triage-flaky-stories` | Finds unstable and quarantined stories and fixes what makes them flaky |
| `reduce-snapshot-usage` | Shows where your snapshots go and proposes story changes that use fewer |
| `find-existing-component` | Checks your repository and published Storybook for a component before a new one is built |
| `run-build` | Runs a Chromatic build for just the stories you are changing |
| `query-chromatic` | Answers any other question about your Chromatic data |
| `check-project-setup` | Checks that this repository is connected to the right Chromatic project |
| `connect-project` | Finds your Chromatic project id and saves it to `chromatic.config.json` |

**Three hooks, in Claude Code only.** In a repository with a `chromatic.config.json`, they remind your agent to check Chromatic when a session starts and after it pushes or opens a pull request. One waits in the background for the build and wakes your agent when it finishes. The hooks add notes for your agent and nothing else: they start no build and change nothing. Codex gets no hooks from this plugin.

## 💬 Use it

Ask in plain words:

- "What's the latest Chromatic build on this branch?"
- "Is this branch ready to merge?"
- "Show me the visual changes on this branch."
- "Fix the broken stories on the last build."
- "Fix the accessibility violations Chromatic found."

To run a skill by name, type `/chromatic:get-latest-build` in Claude Code or `$get-latest-build` in Codex. Every skill in the table works the same way.

**Your project id.** The tools need it, and it lives in `chromatic.config.json` at the root of your repository, as `projectId`. If the file is missing, your agent finds the project from your git remote or asks you for a link to it, then writes the file. The id is the `appId` in any Chromatic project URL. It is not your project token.

**After a push.** When your agent pushes or opens a pull request, it looks for the Chromatic build of that commit and tells you what it found. When changes are waiting for review, it shows you the ones that need a look. It asks before it accepts anything you did not name.

<details>
<summary><strong>Running without a person to approve tool calls</strong></summary>

<br/>

A run such as `claude -p` needs the tools allowed by name. With the plugin, the names start with `mcp__plugin_chromatic_chromatic__`. This allows every tool that only reads:

```
claude -p "Is this branch ready to merge from Chromatic's side?" \
  --allowedTools "mcp__plugin_chromatic_chromatic__chromatic_get_latest_build,mcp__plugin_chromatic_chromatic__chromatic_query,mcp__plugin_chromatic_chromatic__chromatic_search_schema,mcp__plugin_chromatic_chromatic__chromatic_list_accessibility_changes,mcp__plugin_chromatic_chromatic__chromatic_get_accessibility_diff,mcp__plugin_chromatic_chromatic__chromatic_server_time"
```

Leave `chromatic_mutate` out. The machine must have logged in once through `/mcp` first.

</details>

## 🔐 What your agent can see and do

- **It acts as you.** You log in once per agent, in your browser, with your Chromatic account. There is no API key to create and no token to paste. Your agent sees only the projects your account can see, and can do only what your account can do.
- **It reads, and changes only when asked.** It reads builds, tests, accessibility results, published Storybooks and your account. The one change it can make is to accept, deny, quarantine or unquarantine a test, and the skills ask you first unless you named the tests.
- **The hooks stay on your machine.** They read your local git repository. The build watcher also reads Chromatic's status on your commit from GitHub, through the `gh` CLI you are already signed in to. They send nothing to Chromatic.
- **Usage records are small.** For each tool call, Chromatic records the tool's name, whether it worked, how long it took and the project it named. They do not include your agent's questions or the answers. See the [privacy policy](https://www.chromatic.com/docs/privacy-policy).

## 🔄 Update or remove

| | Update | Remove |
| --- | --- | --- |
| Claude Code | `claude plugin marketplace update chromatic`, then `claude plugin update chromatic@chromatic` and restart | `claude plugin uninstall chromatic@chromatic` |
| Codex | `codex plugin marketplace upgrade chromatic` | `codex plugin remove chromatic@chromatic` |

If an update does not arrive, remove the plugin and install it again.

## 🧰 Troubleshooting

**The tools work but the skills are missing.** The server was added on its own, as a connector or with `mcp add`. Install the plugin as shown above.

**Chromatic is listed twice.** You have it as a connector and as a plugin. Claude Code connects once and ignores the duplicate, so this is harmless.

**Your agent cannot find your project.** Run the `connect-project` skill and paste a link to the project. The project id is not your project token.

**You want the Storybook MCP server.** Chromatic also hosts an MCP server for each published Storybook, which serves that Storybook's components and docs. This plugin does not add it, because its address includes your project id. See the [Chromatic MCP docs](https://www.chromatic.com/docs/mcp).

## 🛟 Support

For help with the plugin, a build or your account, contact [Chromatic support](https://www.chromatic.com/docs/support). To report a security problem, see [SECURITY.md](SECURITY.md).

---

<div align="center">
<sub>Made by <a href="https://www.chromatic.com">Chromatic</a>, the visual testing and review tool from the Storybook maintainers.</sub>
</div>
