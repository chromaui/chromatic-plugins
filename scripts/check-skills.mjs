// Checks every skill against the Agent Skills specification
// (https://agentskills.io/specification). No dependencies: the frontmatter is
// flat YAML, so each top-level key is a line that starts at column 0.
import { readdirSync, readFileSync, existsSync } from 'node:fs';
import { join } from 'node:path';

const root = process.argv[2];
const allowed = new Set(['name', 'description', 'license', 'compatibility', 'metadata', 'allowed-tools']);
const errors = [];

for (const dir of readdirSync(root, { withFileTypes: true })) {
  if (!dir.isDirectory()) continue;
  const file = join(root, dir.name, 'SKILL.md');
  if (!existsSync(file)) {
    errors.push(`${dir.name}: no SKILL.md`);
    continue;
  }
  const text = readFileSync(file, 'utf8');
  const match = text.match(/^---\n([\s\S]*?)\n---\n/);
  if (!match) {
    errors.push(`${file}: no frontmatter`);
    continue;
  }
  const fields = {};
  for (const line of match[1].split('\n')) {
    const key = line.match(/^([A-Za-z][\w-]*):\s?(.*)$/);
    if (key) fields[key[1]] = key[2];
  }
  for (const key of Object.keys(fields)) {
    if (!allowed.has(key)) errors.push(`${file}: "${key}" is not an Agent Skills field; put client-specific data elsewhere`);
  }
  const { name = '', description = '' } = fields;
  if (name !== dir.name) errors.push(`${file}: name "${name}" must match its folder "${dir.name}"`);
  if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(name) || name.length > 64) errors.push(`${file}: name "${name}" is not 1-64 lowercase letters, digits and single hyphens`);
  if (description.length < 1 || description.length > 1024) errors.push(`${file}: description must be 1-1024 characters, is ${description.length}`);
  if (text.split('\n').length > 500) errors.push(`${file}: over 500 lines; move detail into references/`);
  for (const link of text.matchAll(/\]\(([^)#\s]+)/g)) {
    const target = link[1];
    if (/^[a-z]+:/.test(target)) continue;
    if (target.startsWith('/') || target.startsWith('../')) errors.push(`${file}: "${target}" points outside the skill's folder`);
    else if (!existsSync(join(root, dir.name, target))) errors.push(`${file}: "${target}" does not exist`);
  }
}

if (errors.length) {
  console.error(errors.join('\n'));
  process.exit(1);
}
console.log('Every skill follows the Agent Skills specification.');
