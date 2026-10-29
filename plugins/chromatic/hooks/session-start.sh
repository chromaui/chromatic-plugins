#!/bin/sh
# Tells the agent, once per session, that this repository is tested by
# Chromatic. Without it nothing prompts a review after a push.
. "$(dirname "$0")/lib.sh"

read_payload
config=$(chromatic_config)
[ -n "$config" ] || exit 0

# The path comes from the repository, which may not be the person's own, and
# it lands in the agent's context and in JSON. Pass on a plain path only.
case "$config" in
  *[!A-Za-z0-9._/-]*) config=chromatic.config.json ;;
esac

add_context SessionStart "This repository is tested by Chromatic (${config}). After you push a commit or open a pull request that changes components, styles, tokens or stories, do not end your turn there: find the Chromatic build for that commit, and when it has changes waiting for review, run the review-visual-changes skill and show the person what changed. When the build is broken, run fix-broken-stories. Before saying a branch can merge, run check-merge-readiness. A go-ahead such as ship it or looks good is not a request to accept in Chromatic: run review-visual-changes, ask one question that names the tests and the build, and wait for the answer. When the person names the tests to accept or deny, that is the request: do it without asking again. If no Chromatic tools are available in this session, the Chromatic server is signed out or not connected: say so once, tell the person to run /mcp to sign in to Chromatic, and carry on with the work they asked for."
