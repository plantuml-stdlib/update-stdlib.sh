#!/usr/bin/env bash

get_local_version() {
    local sContent sLocalVersion

    readonly sContent="${1?One parameter required: <content>}"

    sLocalVersion=$(echo "${sContent}" | grep -E '^VERSION=' | grep -oE '([0-9]+\.?){3}')

    if echo "${sLocalVersion}" | grep --quiet '\.0[0-9]';then
        # Remove unneeded leading zero
        sLocalVersion="$(echo "${sLocalVersion}" | tr '.' "\n" | bc | tr "\n" '.')"
        sLocalVersion="${sLocalVersion:0:-1}"
    fi

    echo "${sLocalVersion}"
}
