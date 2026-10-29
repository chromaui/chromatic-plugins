# Conventions

## Contents

- [Ids](#ids)
- [Pagination](#pagination)
- [Aliases](#aliases)
- [Answer size](#answer-size)
- [What the login can read](#what-the-login-can-read)
- [What the API cannot answer](#what-the-api-cannot-answer)

## Ids

- Ids are opaque strings shaped like `Build:5d67dc0374b2e300209c41e7`. Pass an
  id exactly as a previous response or tool returned it. Do not build one by
  hand.
- A project id comes from `chromatic.config.json` or from a project URL's
  `appId=` parameter. A project token is not a project id.
- A `storyId` is Storybook's own id, such as `button--primary`. It is a string
  argument, not an `ID`.
- There is no root `node(id:)` field. A test, comparison or comment thread id
  cannot be looked up on its own; reach it again from `build(id:)` with a
  `storyId` filter.

## Pagination

Lists that can grow are connections: `first` and `after` page forward, `last`
and `before` page backward, and each connection has `nodes`, `edges`,
`pageInfo { hasNextPage endCursor }` and `totalCount`. Without `first` or
`last` a page holds 100 items; the most one page can hold is 1,000. Start with 20.

`Project.branchNames` is a plain list capped by `limit`, not a connection. It
can leave out branches that have builds, so never use it to decide that a
branch has no build: look the branch up with `lastBuild(branches:)` instead.

## Aliases

The API allows at most one alias per query. These count names are exempt,
and any number of them can sit in one query: `pendingCount`, `brokenCount`,
`deniedCount`, `acceptedCount`, `passedCount`, `ignoredCount`,
`inProgressCount`, `errorCount` and `reviewableCount`. They are names a query
gives a `testCount`, as in `brokenCount: testCount(statuses: [BROKEN])`, not
fields on a build. A second alias under any other name gets the generic
refusal "Your query doesn't match the schema", which does not name the alias,
so use one of these names or split the query in two.

## Answer size

An answer over 100,000 characters is refused whole. Image URLs are the usual
cause: each is about 1,000 characters, and a comparison can carry four. Ask
for images one story at a time, and leave `baseCapture` out until the diff
does not tell you enough.

## What the login can read

| Root field                                         | Scope                   | From the Chromatic MCP           |
| -------------------------------------------------- | ----------------------- | -------------------------------- |
| `project(id:)`                                     | `project:read`          | Yes                              |
| `build(id:)`                                       | `build:read`            | Yes                              |
| `storybook(url:)`                                  | `storybook:read`        | Yes                              |
| `viewer`                                           | `user:read`             | Yes                              |
| `account(id:)`                                     | `account:read`          | Yes                              |
| `figmaMetadata` and friends                        | `metadata:read`         | No                               |
| `reviewTest`, `testQuarantine`, `testUnquarantine` | `build:write`           | Yes, with `chromatic_mutate`     |
| `projectCreate`                                    | `project:write`         | Yes, with `chromatic_mutate`     |
| `createOAuthClient`, `oAuthClientCreate`           | `account:write`         | No, the Chromatic MCP refuses it |
| Any other mutation                                 | a scope the login lacks | No                               |

Once a root field is allowed, everything nested under it is readable,
except `Project.account`, which needs `account:read` too.

`user:read`, `account:read`, `account:write`, `build:write` and
`project:write` came later than the other three. A login from before them is refused for what they cover, and logging
in again fixes it.

## What the API cannot answer

These are not in the public API. Do not search for them, and do not infer
them from other fields. Point the user at the build's `webUrl` instead.

- Listing builds without a project id. There is no top-level list; start
  from `project(id:)`. To find a project id, see
  [projects for a repository](recipes.md#projects-for-a-repository).
- TurboSnap: whether it ran, why it bailed, which files it traced.
- Pixel counts for a visual diff.
- An accessibility violation's impact, HTML, or failure summary. A violation
  element carries its CSS selector only.
- Starting, rerunning or cancelling a build. Builds come from the Chromatic
  CLI; see the `run-build` skill.
- Replying to or resolving comments.
