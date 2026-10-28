# Shared by the hooks. Prints the path of the repository's chromatic.config.json,
# relative to the repository root, or nothing when the repository has none.
# Silent outside a git repository, so the hooks cost nothing elsewhere.
chromatic_config() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
  git ls-files --cached --others --exclude-standard -- \
    'chromatic.config.json' '**/chromatic.config.json' 2>/dev/null | head -n 1
}

# Prints one JSON object that adds $2 to the agent's context for event $1.
# The text must not contain a double quote or a backslash.
add_context() {
  printf '{"hookSpecificOutput":{"hookEventName":"%s","additionalContext":"%s"}}\n' "$1" "$2"
}

# Reads the hook's payload on stdin into $payload, then moves to the top of
# the repository the agent is working in, which the payload names as "cwd".
# Every git and gh command must run there: in a Claude desktop app worktree
# session the hook starts in the main checkout, whose HEAD is not the commit
# the agent just pushed. Stays where it started when the payload names no
# directory it can enter.
read_payload() {
  payload=$(cat)
  cwd=$(payload_string cwd | sed 's/\\\(.\)/\1/g')
  [ -n "$cwd" ] && cd "$cwd" >/dev/null 2>&1 || return 0
  top=$(git rev-parse --show-toplevel 2>/dev/null) && cd "$top" >/dev/null 2>&1
  return 0
}

# Prints the string value of key $1 in $payload, still JSON-escaped. Text the
# command printed is escaped in the payload, so a quoted key can only be one
# of the payload's own.
payload_string() {
  printf '%s\n' "$payload" |
    sed -nE 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' | head -n 1
}

# Succeeds when the command the agent ran, read from $payload, was a push or
# a new pull request, which is the moment a build starts.
is_push() {
  # The command as the agent wrote it.
  command=$(payload_string command)

  git_push='git([[:space:]]+-[^[:space:]]+([[:space:]]+[^-[:space:]][^[:space:]]*)?)*[[:space:]]+push'
  new_pull_request='gh[[:space:]]+pr[[:space:]]+create'

  printf '%s' "$command" |
    grep -Eq "(^|[^[:alnum:]_-])(${git_push}|${new_pull_request})([^[:alnum:]_-]|\$)" || return 1
  printf '%s' "$command" | grep -q -- '--dry-run' && return 1

  return 0
}

# Prints where Chromatic's UI Tests status stands on commit $1, read from
# GitHub: none, running or done. Prints nothing when GitHub cannot be asked.
# Only these fixed words leave this function, never text from the status.
ui_tests_status() {
  gh api "repos/{owner}/{repo}/commits/$1/status" --jq '
    [.statuses[] | select(.context | startswith("UI Tests"))]
    | if length == 0 then "none"
      elif any(.description // "" | startswith("Running")) then "running"
      else "done" end' 2>/dev/null
}

# Succeeds when watch-build.sh can tell the agent that a build has finished.
can_watch_build() {
  command -v gh >/dev/null 2>&1 || return 1
  [ -n "$(ui_tests_status "$(git rev-parse HEAD 2>/dev/null)")" ]
}
