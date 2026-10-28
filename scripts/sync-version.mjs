// Copies the version `changeset version` wrote into package.json to every
// manifest an agent reads. Each manifest keeps its own copy because each agent
// reads only its own file, and CI fails when they disagree.
import { readFileSync, writeFileSync } from 'node:fs';

const { version } = JSON.parse(readFileSync('package.json', 'utf8'));

const targets = [
  ['plugins/chromatic/.claude-plugin/plugin.json', (manifest) => (manifest.version = version)],
  ['plugins/chromatic/.codex-plugin/plugin.json', (manifest) => (manifest.version = version)],
  ['.claude-plugin/marketplace.json', (manifest) => (manifest.plugins[0].version = version)],
];

for (const [path, set] of targets) {
  const text = readFileSync(path, 'utf8');
  const manifest = JSON.parse(text);

  set(manifest);

  // A targeted replace, not a re-serialise: JSON.stringify would expand the
  // inline arrays and turn a one-line bump into a reformat of the whole file.
  const updated = text.replace(/("version":\s*")[^"]+(")/, `$1${version}$2`);

  if (JSON.stringify(JSON.parse(updated)) !== JSON.stringify(manifest)) {
    throw new Error(`${path}: the first "version" key is not the one that should change`);
  }

  writeFileSync(path, updated);
  console.log(`${path} -> ${version}`);
}
