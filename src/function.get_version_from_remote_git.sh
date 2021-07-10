#!/usr/bin/env bash

get_version_from_remote_git() {
    local sProject sRemoteVersion

    readonly sProject="${1?One parameter required: <github-project>}"

    readonly sRemoteVersion="$("${GIT}" ls-remote --tags "git://github.com/${sProject}.git" \
        | cut -d'/' -f3         \
        | grep -E '^v?[0-9.]+$' \
        | grep -oE '[0-9.]+'    \
        | sort -V               \
        | tail -n1)" || true

    echo "${sRemoteVersion}"
}
