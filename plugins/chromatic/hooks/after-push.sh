#!/bin/sh
# Runs after every shell command the agent makes, and speaks only after a
# push or a new pull request in a repository tested by Chromatic. That is the
# moment a build starts, and the agent cannot see it unless it is told.
. "$(dirname "$0")/lib.sh"

read_payload
is_push || exit 0
[ -n "$(chromatic_config)" ] || exit 0

if can_watch_build; then
  still_running="If it is still running after that, tell the person and end your turn: you will be woken when the build finishes."
else
  still_running="If you cannot wait, tell the person the build is running and that you can review it when they ask."
fi

add_context PostToolUse "If that push went through, Chromatic is about to build this commit. Before you end your turn, call chromatic_wait_for_build with this branch and the output of git rev-parse HEAD. While it says to call again, call again: the tool does the waiting. Then: PENDING, run the review-visual-changes skill and show the person the changes; BROKEN, run fix-broken-stories; PASSED or ACCEPTED, say so in one line. ${still_running}"
