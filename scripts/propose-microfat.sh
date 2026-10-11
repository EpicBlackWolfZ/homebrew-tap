#!/usr/bin/env bash
# Run only after the native qualification jobs, in a clean trusted tap checkout.
set -euo pipefail
IFS=$'\n\t'

if [[ "$#" -ne 3 ]]; then
    echo 'usage: propose-microfat.sh TAG CANDIDATE_DIRECTORY TOOLING_DIRECTORY' >&2
    exit 2
fi
tag="${1}"
candidate="$(realpath -- "${2}")"
tooling="$(realpath -- "${3}")"
tap_root="$(git rev-parse --show-toplevel)"
repository='EpicBlackWolfZ/homebrew-tap'
branch="chore/microfat-${tag}"
if [[ ! "${tag}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ || "${PWD}" != "${tap_root}" ]]; then
    echo 'an exact stable tag and the tap repository root are required' >&2
    exit 1
fi
remote="$(git remote get-url origin)"
if [[ "${remote}" != "https://github.com/${repository}" && "${remote}" != "https://github.com/${repository}.git" ]]; then
    echo 'refusing to publish to a different repository' >&2
    exit 1
fi
status="$(git status --porcelain --untracked-files=no)"
if [[ -n "${status}" ]]; then
    echo 'tracked working tree changes must be reviewed separately' >&2
    exit 1
fi
mkdir -p .work
recheck="$(mktemp -d "${PWD}/.work/recheck.XXXXXX")"
latest="$(cd -- "${tooling}" && go run ./internal/cmd/homebrew-release discover)"
if [[ "${latest}" != "${tag}" ]]; then
    echo 'candidate is no longer the latest eligible stable release' >&2
    exit 1
fi
(cd -- "${tooling}" && go run ./internal/cmd/homebrew-release prepare --tag "${tag}" --output "${recheck}/verified")
cmp -- "${candidate}/microfat.rb" "${recheck}/verified/microfat.rb"
git fetch --quiet origin main
current="${recheck}/current.rb"
if git cat-file -e origin/main:Casks/microfat.rb 2>/dev/null; then
    git show origin/main:Casks/microfat.rb > "${current}"
else
    : > "${current}"
fi
needed="$(cd -- "${tooling}" && go run ./internal/cmd/homebrew-release update-needed \
    --cask "${current}" --candidate "${recheck}/verified/microfat.rb")"
if [[ "${needed}" == false ]]; then
    echo 'The authenticated recipe is already current.'
    exit 0
fi
[[ "${needed}" == true ]]
remote_branch="$(git ls-remote --heads origin "refs/heads/${branch}")"
if [[ -n "${remote_branch}" ]]; then
    git fetch --quiet origin "${branch}"
    git show FETCH_HEAD:Casks/microfat.rb > "${recheck}/existing.rb"
    cmp -- "${recheck}/existing.rb" "${recheck}/verified/microfat.rb"
    changed_paths="$(git diff --name-only origin/main...FETCH_HEAD)"
    [[ "${changed_paths}" == Casks/microfat.rb ]]
else
    git switch --quiet -c "${branch}" origin/main
    mkdir -p Casks
    cp -- "${recheck}/verified/microfat.rb" Casks/microfat.rb
    git add -- Casks/microfat.rb
    changed_paths="$(git diff --cached --name-only)"
    [[ "${changed_paths}" == Casks/microfat.rb ]]
    git -c user.name='github-actions[bot]' -c user.email='41898282+github-actions[bot]@users.noreply.github.com' \
        commit --quiet -m "chore(microfat): update cask to ${tag}"
    git push origin "HEAD:refs/heads/${branch}"
fi
pr_state="$(gh pr list --repo "${repository}" --head "${branch}" --state all --json state --jq '.[0].state // ""')"
if [[ "${pr_state}" == OPEN ]]; then
    gh pr view "${branch}" --repo "${repository}" --json url --jq .url
    exit 0
fi
if [[ -n "${pr_state}" ]]; then
    echo 'An earlier PR is closed or merged; review the conflict manually.' >&2
    exit 1
fi
body="${recheck}/body.md"
evidence='See the Update microfat workflow run that created this PR.'
if [[ -n "${GITHUB_RUN_ID:-}" ]]; then
    evidence="https://github.com/${repository}/actions/runs/${GITHUB_RUN_ID}"
fi
cat > "${body}" <<EOF
Install the official microfat ${tag} Linux amd64/arm64 release with fixed archive hashes.

The immutable public release was authenticated against its exact workflow/tag, issuer and source SHA.
Both native Homebrew qualification jobs passed before this PR was created. Their workflow run retains
the verification evidence and lifecycle logs. All three executable products remain byte-identical.

Qualification evidence: ${evidence}

Approve the generated PR workflows, review their results, and merge manually.

Refs EpicBlackWolfZ/microfat#205.
EOF
gh pr create --repo "${repository}" --base main --head "${branch}" \
    --title "chore(microfat): update cask to ${tag}" --body-file "${body}"
