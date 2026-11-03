// Builds the ZIP for OpenAI's plugin directory from the Agent Plugins package.
//
//   npm run openai-zip            writes chromatic-openai-plugin-<version>.zip
//   npm run openai-zip -- out.zip writes out.zip
//
// The ZIP's mcp.json gains OpenAI's sign-in settings, which the submission
// portal reads from there: OAuth with CIMD client registration, because
// Chromatic's authorization server has no dynamic registration endpoint.
//
// They go into the ZIP only, not the package in the repository. Codex 0.166
// drops an MCP server whose mcp.json entry has an `extensions` key, even an
// empty one, so a Codex install of the package would lose the server. CI keeps
// the package's mcp.json free of `extensions` for the same reason.
import { cpSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { execFileSync } from 'node:child_process';

const PACKAGE = 'plugins/chromatic/agent-plugin';
const AUTH = { type: 'oauth', client: { mode: 'cimd' } };

const { version } = JSON.parse(readFileSync(join(PACKAGE, 'plugin.json'), 'utf8'));
const out = resolve(process.argv[2] ?? `chromatic-openai-plugin-${version}.zip`);

const staging = mkdtempSync(join(tmpdir(), 'chromatic-openai-zip-'));
try {
  cpSync(PACKAGE, staging, { recursive: true });

  const mcpPath = join(staging, 'mcp.json');
  const mcp = JSON.parse(readFileSync(mcpPath, 'utf8'));
  const servers = Object.values(mcp.mcpServers);
  if (servers.length !== 1) throw new Error(`expected one MCP server, found ${servers.length}`);
  servers[0].extensions = { 'com.openai': { auth: AUTH } };
  writeFileSync(mcpPath, JSON.stringify(mcp, null, 2) + '\n');

  rmSync(out, { force: true });
  // plugin.json at the root of the archive, without dotfiles.
  execFileSync('zip', ['-qrX', out, '.', '-x', '.*', '*/.*'], { cwd: staging, stdio: 'inherit' });
  console.log(`${out} (version ${version})`);
} finally {
  rmSync(staging, { recursive: true, force: true });
}
