#!/bin/sh
# Runs in the background after a push or a new pull request, in Claude Code.
# A build takes minutes and the agent's turn often ends first, so this waits
# for Chromatic's UI Tests status on the pushed commit and wakes the agent
# when the build has finished. It reads that status from GitHub with gh and
# changes nothing. Without gh, or off GitHub, it stays silent.
. "$(dirname "$0")/lib.sh"

read_payload
is_push || exit 0
[ -n "$(chromatic_config)" ] || exit 0
command -v gh >/dev/null 2>&1 || exit 0

commit=$(git rev-parse HEAD 2>/dev/null) || exit 0

# About thirteen minutes, inside the hook's timeout.
polls=40
unanswered=0

while [ "$polls" -gt 0 ]; do
  # A newer commit gets its own build and its own watch.
  [ "$(git rev-parse HEAD 2>/dev/null)" = "$commit" ] || exit 0

  case "$(ui_tests_status "$commit")" in
    done)
      echo "Chromatic has finished the build for commit $(git rev-parse --short "$commit"). If you have already told the person this build's result, do nothing and say nothing more. Otherwise call chromatic_get_latest_build for this branch, then: PENDING, run the review-visual-changes skill and show the person the changes; BROKEN, run fix-broken-stories; PASSED or ACCEPTED, say so in one line." >&2
      exit 2
      ;;
    none | running)
      unanswered=0
      ;;
    *)
      unanswered=$((unanswered + 1))
      [ "$unanswered" -lt 3 ] || exit 0
      ;;
  esac

  polls=$((polls - 1))
  sleep 20
done

exit 0
