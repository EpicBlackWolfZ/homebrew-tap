# Tap maintenance

This shared tap is maintained through reviewed pull requests. Never push package
updates directly to main or automatically merge pull requests.

Microfat uses authenticated immutable Linux release archives. Do not rewrite or
strip its executables, change its hashes by hand, add unsigned download paths, or
invoke its installer from the cask. Its generator and qualification harness live
in EpicBlackWolfZ/microfat at the reviewed commit in microfat-tools.ref.

Run pinned Task v3.53.1. `task check` requires ShellCheck v0.11.0 and tests the
update script. `task qualify` requires the pinned upstream tooling checkout at
microfat-tools and Go 1.27.1; it uses a disposable Homebrew prefix.

All Bash scripts use `#!/usr/bin/env bash`, `set -euo pipefail`, and
`IFS=$'\n\t'`. Preserve .shellcheckrc rules without global disables.

Keep microfat automation restricted to Casks/microfat.rb. Future casks have
independent ownership and qualification. No cask is published before its final
public release is authenticated and both native architectures pass qualification.
