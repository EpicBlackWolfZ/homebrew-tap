# Official Homebrew tap

Homebrew packages maintained by EpicBlackWolfZ. This repository can host multiple
casks; each package uses its own release and qualification contract.

## Packages

| Package | Platforms | Availability |
| --- | --- | --- |
| microfat | Linux amd64 and arm64 | Pending the first authenticated v0.3.0 recipe |

After the first microfat recipe PR is merged:

```bash
brew install --cask EpicBlackWolfZ/tap/microfat
brew upgrade --cask microfat
brew reinstall --cask microfat
brew uninstall --cask microfat
```

These commands are not available until that recipe exists. No macOS package or
Homebrew core submission is included. Use a current Homebrew with Linux cask
support; qualification is pinned to Homebrew 7.0.2.

Microfat installs the official fat CLI and full/minimal launcher stubs together
without stripping or rewriting their bytes. Homebrew manages upgrades and
removal. `microfat update --check` remains available; version-changing self-update
is refused with Homebrew guidance. Uninstall does not delete workload files,
microfat caches, or installations managed by another installer.

## Release trust and maintenance

The microfat workflow checks hourly, at minute 17, and can be dispatched manually
for an immediate check or retry. Before v0.3.0 is published it succeeds without
creating a recipe. GitHub scheduling can be delayed; manual dispatch is the
recovery path.

The workflow uses the Go tooling pinned by full SHA in `microfat-tools.ref`.
Before opening a recipe PR it authenticates an exact stable, public, immutable
release, verifies signed checksums against the official workflow/tag identity,
issuer and source commit, validates both archives and their SBOMs, and qualifies
native amd64 and arm64 installations. Homebrew users trust the reviewed tap recipe
and its fixed archive hashes; the recipe does not download or run Cosign.

The tap's own GITHUB_TOKEN creates update PRs. A maintainer must select **Approve
workflows to run**, review the native checks and evidence, and merge manually.
No cross-repository credential or automatic merging is used. Failed runs retain
evidence and leave the current recipe unchanged. Rerun the workflow to retry;
never republish release assets to repair a tap failure.

Tooling pins and workflow changes require separate reviewed PRs. The automated
update changes only `Casks/microfat.rb` and refuses downgrades, conflicting
same-version content and unexpected branch edits. Review closed/conflicting PRs
manually rather than force-pushing over them.

## Development

Install Task v3.53.1, Go 1.27.1 and ShellCheck v0.11.0. Check out
`EpicBlackWolfZ/microfat` at the exact commit in `microfat-tools.ref` into
`microfat-tools/`, then run:

```bash
task check
task qualify
```

Qualification creates a disposable Homebrew installation under `.work`; it does
not modify your existing prefix. An existing qualification directory is refused,
so select a fresh output directory when repeating a run. Controlled fixture
upgrades are distinct from authenticated published-release qualification.
