# What a build's state means

## Status

| Status        | Meaning                                                      | What to do next                                        |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------ |
| `ANNOUNCED`   | The CLI created the build; the Storybook is not uploaded yet | Wait                                                   |
| `PUBLISHED`   | Uploaded, not ready for testing                              | Wait                                                   |
| `PREPARED`    | Ready for testing, not started                               | Wait                                                   |
| `IN_PROGRESS` | Testing stories now                                          | Wait                                                   |
| `SKIPPED`     | No stories were affected, so nothing ran                     | Read the last build that ran; this one tested nothing  |
| `PASSED`      | Every test passed without changes                            | Nothing                                                |
| `PENDING`     | At least one change is waiting for review                    | the `review-visual-changes` skill                      |
| `ACCEPTED`    | Every change was accepted                                    | Nothing                                                |
| `DENIED`      | At least one change was denied                               | Fix what was denied, then build again                  |
| `BROKEN`      | Stories failed to render                                     | the `fix-broken-stories` skill                         |
| `FAILED`      | A Chromatic infrastructure error, usually transient          | Rerun the build; nothing in the repository causes this |
| `CANCELLED`   | Cancelled before it finished                                 | Build again if a result is needed                      |

## Result, once complete

| Result          | Meaning                                        |
| --------------- | ---------------------------------------------- |
| `SUCCESS`       | Every test completed                           |
| `CAPTURE_ERROR` | At least one story failed to capture           |
| `SYSTEM_ERROR`  | At least one test had a Chromatic system error |
| `TIMEOUT`       | The build timed out                            |

## Flags

- `isSuperseded`: a newer build exists on the same branch, and this one can no
  longer be reviewed. Report the newer one instead. `chromatic_get_latest_build`
  does not return `supersededBy`, so read it with `chromatic_query`, using the
  build-by-number recipe in the `query-chromatic` skill. When it is null, look
  up the branch's newest build.
- `isLimited`: UI Tests and UI Review were turned off for the build because
  the account would pass its snapshot quota or has a payment due. It took no
  snapshots, so it tested nothing; say so.
- `error.message`: why the build failed, when it did.
