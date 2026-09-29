#!/usr/bin/env bash
# Exercise publication boundaries with local command doubles; no network or pushes.
set -euo pipefail
IFS=$'\n\t'

script="$(realpath scripts/propose-microfat.sh)"
fixture="$(mktemp -d)"
trap 'rm -rf -- "${fixture}"' EXIT
mkdir -p "${fixture}/bin"
cat > "${fixture}/bin/git" <<'GIT'
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
printf '%s\n' "git ${*}" >> "${TEST_LOG}"
case "${1}" in
    rev-parse) printf '%s\n' "${TEST_ROOT}" ;;
    remote)
        if [[ "${TEST_SCENARIO}" == wrong-remote ]]; then
            echo 'https://github.com/other/repository'
        else
            echo 'https://github.com/EpicBlackWolfZ/homebrew-tap.git'
        fi ;;
    status) if [[ "${TEST_SCENARIO}" == dirty ]]; then echo ' M README.md'; fi ;;
    cat-file) exit 1 ;;
    ls-remote)
        case "${TEST_SCENARIO}" in existing|conflict|closed|unrelated) echo 'abc refs/heads/chore/microfat-v0.3.0' ;; esac ;;
    show)
        if [[ "${TEST_SCENARIO}" == conflict ]]; then echo 'human edit'; else cat "${TEST_CANDIDATE}/microfat.rb"; fi ;;
    diff)
        if [[ "${TEST_SCENARIO}" == unrelated ]]; then echo 'Casks/unrelated.rb'; else echo 'Casks/microfat.rb'; fi ;;
    switch|fetch|add|-c|push) ;;
    *) echo 'unexpected git invocation' >&2; exit 1 ;;
esac
GIT
cat > "${fixture}/bin/go" <<'GO'
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
case "${3}" in
    discover)
        if [[ "${TEST_SCENARIO}" == stale ]]; then echo v0.3.1; else echo v0.3.0; fi ;;
    prepare)
        if [[ "${TEST_SCENARIO}" == authentication ]]; then exit 1; fi
        mkdir -p "${7}"
        if [[ "${TEST_SCENARIO}" == tampered ]]; then
            echo 'authenticated content' > "${7}/microfat.rb"
        else
            cp "${TEST_CANDIDATE}/microfat.rb" "${7}/microfat.rb"
        fi ;;
    update-needed)
        if [[ "${TEST_SCENARIO}" == current ]]; then echo false; else echo true; fi ;;
    *) exit 1 ;;
esac
GO
cat > "${fixture}/bin/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
printf '%s\n' "gh ${*}" >> "${TEST_LOG}"
case "${2}" in
    list)
        if [[ "${TEST_SCENARIO}" == existing ]]; then echo OPEN; fi
        if [[ "${TEST_SCENARIO}" == closed ]]; then echo CLOSED; fi ;;
    view|create) echo 'https://github.com/EpicBlackWolfZ/homebrew-tap/pull/1' ;;
    *) exit 1 ;;
esac
GH
chmod +x "${fixture}/bin/"*
export PATH="${fixture}/bin:${PATH}"
for scenario in fresh current existing stale authentication tampered wrong-remote dirty conflict closed unrelated; do
    export TEST_SCENARIO="${scenario}"
    export TEST_ROOT="${fixture}/${scenario}"
    export TEST_CANDIDATE="${TEST_ROOT}/candidate"
    export TEST_LOG="${TEST_ROOT}/commands.log"
    mkdir -p "${TEST_CANDIDATE}" "${TEST_ROOT}/tooling" "${TEST_ROOT}/Casks"
    echo 'candidate fixture' > "${TEST_CANDIDATE}/microfat.rb"
    echo 'unrelated cask' > "${TEST_ROOT}/Casks/unrelated.rb"
    : > "${TEST_LOG}"
    expected=1
    case "${scenario}" in fresh|current|existing) expected=0 ;; esac
    actual=0
    (cd "${TEST_ROOT}" && bash "${script}" v0.3.0 "${TEST_CANDIDATE}" "${TEST_ROOT}/tooling") \
        > "${TEST_ROOT}/output.log" 2>&1 || actual="${?}"
    if [[ "${actual}" -ne "${expected}" ]]; then
        cat "${TEST_ROOT}/output.log" >&2
        echo "unexpected result for ${scenario}: ${actual}" >&2
        exit 1
    fi
    unrelated="$(cat "${TEST_ROOT}/Casks/unrelated.rb")"
    [[ "${unrelated}" == 'unrelated cask' ]]
    if [[ "${scenario}" != fresh ]] && grep -q '^git push' "${TEST_LOG}"; then
        echo "unexpected push for ${scenario}" >&2
        exit 1
    fi
done
echo 'Microfat publication policy fixtures passed.'
