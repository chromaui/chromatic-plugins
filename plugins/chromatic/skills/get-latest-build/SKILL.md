---
name: get-latest-build
description: Reports the latest Chromatic build for this repository's project, on the current branch unless another branch or a pull request is named. Use when the user asks what Chromatic thinks of their branch or pull request, whether the build passed or is still running, for the build id the accessibility tools need, or right after a push to see whether Chromatic has built the new commit.
argument-hint: "[branch or pull request number]"
---

# Latest Chromatic build

Answer "what is the state of my branch on Chromatic?" with one tool call.

## Steps

1. Get the project id from `chromatic.config.json` at the repository root. If
   the file is missing or has no `projectId`, follow the `connect-project`
   skill first, then return here.
2. If the user named a pull request or merge request, by number or by link,
   follow [From a pull request](#from-a-pull-request) and go on from step 5.
   Otherwise pick the branch: the one the user named when invoking this skill,
   otherwise the output of `git branch --show-current`.
3. Call `chromatic_get_latest_build` with `projectId` and `branches` set to
   `[<branch>]`.
4. If no build matches, call again without `branches`, say plainly that the
   branch has no build yet, and report the project's latest build instead.
5. Report the build number, status, result, the branch and commit it was built
   from, the change and awaiting-review counts, and `webUrl`. If
   `isSuperseded` is true, say a newer build exists. If the build is still in
   progress, say so rather than reading results into it.
6. Compare the build's `commit` with `git rev-parse HEAD`. If they differ,
   say the build is for an older commit. Right after a push the new build may
   not exist yet: ask again in about 30 seconds.

## From a pull request

Run this with `chromatic_query`. `number` is the number in the pull request's
URL. On GitLab it is the merge request's IID.

```graphql
query PullRequestBuild($projectId: ID!, $number: Int!) {
  project(id: $projectId) {
    lastBuildForPullRequest(number: $number) {
      id
      number
      status
      branch
      commit
      isSuperseded
      ... on StartedBuild {
        webUrl
      }
      ... on CompletedBuild {
        webUrl
        result
        testCount
        pendingCount: testCount(statuses: [PENDING])
      }
    }
  }
}
```

It finds builds from forks too, where `branch` reads `owner:branch`.

Null means the pull request has no build, the number does not exist, or
Chromatic cannot ask the git provider, which is always so on Azure DevOps. Say
that plainly and do not report a build from another branch as this pull
request's. If you know the pull request's branch, go back to step 3 with it.

In step 6, compare against the pull request's head commit, not `HEAD`, unless
its branch is checked out.

## Reading the result

Explain the status in one sentence, with what to do next, from
[references/build-states.md](references/build-states.md).

This reports the build, not its test results. For those, follow the skill the
status points to, or the `fix-accessibility-violations` skill for
accessibility. To look a build up by its number, use the `query-chromatic`
skill.
