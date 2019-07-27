#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly ARGS=("$@")

main() {
    local HC_ID=${1:-}
    shift
    local HC_ARGS=("${@:-}")
    if [[ -z ${HC_ID} ]] || [[ -z ${HC_ARGS[*]} ]]; then
        exit 1
    fi

    (curl -fsS --retry 3 https://hc-ping.com/"${HC_ID}"/start || true)
    eval "${HC_ARGS[@]:-}" || (
        curl -fsS --retry 3 https://hc-ping.com/"${HC_ID}"/fail || true
        exit 1
    )
    (curl -fsS --retry 3 https://hc-ping.com/"${HC_ID}" || true)
}
main "${ARGS[@]:-}"
