# Official Homebrew tap

Homebrew packages maintained by EpicBlackWolfZ. This repository can host multiple
casks; each package uses its own release and qualification contract.

## Packages

| Package | Platforms | Availability |
| --- | --- | --- |
| [microfat v0.3.1](https://github.com/EpicBlackWolfZ/microfat/releases/tag/v0.3.1) | Linux amd64 and arm64 | Available; authenticated recipe and native public installation accepted |

Install, upgrade, reinstall or remove microfat with:

```bash
brew install --cask EpicBlackWolfZ/tap/microfat
brew upgrade --cask microfat
brew reinstall --cask microfat
brew uninstall --cask microfat
```

The cask supports Linux amd64 and arm64. Native macOS remains
[future work](https://github.com/EpicBlackWolfZ/microfat/issues/17); no Homebrew core submission
is included. Use a current Homebrew with Linux cask
support; qualification follows `HOMEBREW_SOURCE` in the reviewed upstream
tooling's `.config/tool-versions.env`.

Microfat installs the official fat CLI and full/minimal launcher stubs together
without stripping or rewriting their bytes. Homebrew manages upgrades and
removal. `microfat update --check` remains available; version-changing self-update
is refused with Homebrew guidance. Uninstall does not delete workload files,
microfat caches, or installations managed by another installer.

Public installation acceptance checks same-version upgrades. Cross-version upgrades and
checksum-failure recovery use controlled fixtures; those fixtures do not prove an upgrade between
two published microfat versions.

## v0.3.1 acceptance evidence

[v0.3.1](https://github.com/EpicBlackWolfZ/microfat/releases/tag/v0.3.1), source
`94cb9f6ad26c14931ea28e53a8969f09790eff80`, was published as immutable release `421362795`
on 2026-10-23 at 05:04:02 UTC. The authenticated recipe has SHA-256
`786861ca85631f646b9e8ad4d6efbb70c92501d2e166d9d4c20d998cf49c326a`.

[Update microfat 39903752644, attempt 1](https://github.com/EpicBlackWolfZ/homebrew-tap/actions/runs/39903752644/attempts/1)
authenticated the release and passed native amd64/arm64 lifecycle qualification before proposing
[recipe PR #7](https://github.com/EpicBlackWolfZ/homebrew-tap/pull/7). Its exact head
`fba5d11321f41380ef14c40f63e79e797584006b` passed all four
[Tap CI checks](https://github.com/EpicBlackWolfZ/homebrew-tap/actions/runs/39904088128/attempts/2).
Attempt 1 required workflow approval; the approved attempt 2 completed successfully.
The reviewed recipe merged as `ff68d3692df5aa2271e4f803418ed95c5c31b8cd`.

Qualification used reviewed upstream tooling `ada376b4ffffaa3354becbfb70c1896934caf277`,
Go 1.27.3 and Homebrew 7.0.10 revision `8f10429b56be28a25032b87463fffc95e556b5bc`.
Each native qualification recorded 102 commands: 91 successes, ten expected Homebrew self-update
refusals and one expected corrupt-checksum upgrade refusal. These controlled checks retain their
own scope, separately from installation through the official public tap.

[Public installation acceptance 39904442888, attempt 1](https://github.com/EpicBlackWolfZ/microfat/actions/runs/39904442888/attempts/1)
passed all four native installer/Homebrew jobs at qualification and product source
`94cb9f6ad26c14931ea28e53a8969f09790eff80`, using the reviewed recipe merge above.
Both official remote tap installations passed install, reinstall, same-version upgrade and
conservative uninstall. All three installed product hashes matched authenticated release bytes.
Full/minimal launchers executed packed payloads in both memfd and cache modes.
The [upstream acceptance record](https://github.com/EpicBlackWolfZ/microfat/blob/main/docs/releases/v0.3.1.md#release-acceptance)
retains the separate product, benchmark, signed-candidate and public installation evidence.
Documentation in immutable product archives remains frozen.

## v0.3.0 acceptance evidence

[v0.3.0](https://github.com/EpicBlackWolfZ/microfat/releases/tag/v0.3.0), source
`d3883d59674eb32351717f6d28744862d1cc45c9`, was published as immutable release `411193467`
on 2026-10-13 at 05:25:54 UTC. Its authenticated recipe has SHA-256
`0f8dfea590d2186e42c94485ba23d721bef83d74bf993a9566b547e6e4a430c4`.

[Update microfat 38352077381, attempt 1](https://github.com/EpicBlackWolfZ/homebrew-tap/actions/runs/38352077381/attempts/1)
authenticated the release and passed native amd64/arm64 lifecycle qualification before proposing
[recipe PR #4](https://github.com/EpicBlackWolfZ/homebrew-tap/pull/4). Its exact head
`33c2dde4faab9a04dd4b2c841c57d94911efb1b3` passed all four
[Tap CI checks](https://github.com/EpicBlackWolfZ/homebrew-tap/actions/runs/38352360124/attempts/2).
The reviewed recipe merged as `87061d5bd8411a3e729ad5a6d25925ff76f669bb`.

[Public installation acceptance 38376089070, attempt 2](https://github.com/EpicBlackWolfZ/microfat/actions/runs/38376089070/attempts/2)
passed all four native installer/Homebrew jobs; both official remote tap legs were independently
verified at that recipe merge SHA. Each Homebrew leg passed 52 commands: 46 successes and six expected
self-update refusals. All three product hashes matched authenticated release bytes after install,
reinstall and same-version upgrade. Twelve automatic full/minimal memfd/cache payload executions and
conservative uninstall passed per architecture, using pinned Homebrew 7.0.2 revision
`83c9802fb54c60a612d52b264808c099b39a0687`.

Qualification source `5f09b0185b1c51daa54a641d7241ac111c340555` includes the reviewed
[harness and test-fixture corrections](https://github.com/EpicBlackWolfZ/microfat/pull/356), separately
from immutable product source `d3883d59674eb32351717f6d28744862d1cc45c9`. Original ZIP hashes, sizes,
complete CRCs and exact-source Cosign authentication were independently verified. Public Homebrew
checks used fresh disposable prefixes on provisioned native Linux hosts. The workload sentinel was
physically retained and reviewed; ownership, removal and other preservation checks are attested by
reviewed script assertions and successful jobs. These finite results do not qualify every Linux host.
Recipe qualification and public remote installation retain separate evidence. This README was updated
after immutable publication; documentation in the tagged product archives remains frozen.

Earlier failed cohorts are retained in the upstream
[acceptance record](https://github.com/EpicBlackWolfZ/microfat/blob/main/docs/releases/v0.3.0.md#release-acceptance).
[38364455323/1](https://github.com/EpicBlackWolfZ/microfat/actions/runs/38364455323/attempts/1)
stopped Homebrew before remote installation on a valid multiline version report.
[38376089070/1](https://github.com/EpicBlackWolfZ/microfat/actions/runs/38376089070/attempts/1)
stopped amd64 in a prerequisite historical v0.2.5 fixture update check on HTTP 403, before official
remote installation; its external cause is unknown. Neither failure establishes a product bug.
Final acceptance uses all four fresh attempt-2 jobs, without combining cohorts.

## Release trust and maintenance

The microfat workflow checks hourly, at minute 17, and can be dispatched manually
for an immediate check or retry. When no eligible immutable public release exists, it succeeds
without creating a recipe. GitHub scheduling can be delayed; manual dispatch is the
recovery path.

The workflow uses the Go tooling pinned by full SHA in `microfat-tools.ref`.
Before opening a recipe PR it authenticates an exact stable, public, immutable
release, verifies signed checksums against the official workflow/tag identity,
issuer and source commit, validates both archives and their SBOMs, and qualifies
native amd64 and arm64 installations. Homebrew users trust the reviewed tap recipe
and its fixed archive hashes; the recipe does not download or run Cosign.

The tap's own GITHUB_TOKEN creates update PRs. If GitHub marks a generated PR workflow as requiring
approval, a maintainer approves that run, reviews its native checks and evidence, and merges manually.
An explicit `ci.yml` dispatch on the recipe branch is the supported fallback for a missing run;
approve an existing waiting run instead of dispatching a duplicate. Approval-required runs and
event suppression by GITHUB_TOKEN are separate conditions.
No cross-repository credential or automatic merging is used. Failed runs retain
evidence and leave the current recipe unchanged. Rerun the workflow to retry;
never republish release assets to repair a tap failure.

Tooling pins and workflow changes require separate reviewed PRs. The automated
update changes only `Casks/microfat.rb` and refuses downgrades, conflicting
same-version content and unexpected branch edits. Review closed/conflicting PRs
manually rather than force-pushing over them.

## Development

Install Task v3.54.0, Go 1.27.3 and ShellCheck v0.11.0. Check out
`EpicBlackWolfZ/microfat` at the exact commit in `microfat-tools.ref` into
`microfat-tools/`. CI reads these Go and tool pins from that reviewed checkout.
Then run:

```bash
task check
task qualify
# Repeat qualification with fresh staging:
task qualify OUTPUT=.work/qualification-2
```

Qualification creates a disposable Homebrew installation under `.work`; it does
not modify your existing prefix. An existing qualification directory is refused,
so select a fresh output directory when repeating a run. Controlled fixture
upgrades are distinct from authenticated published-release qualification.
