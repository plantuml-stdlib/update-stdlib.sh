#!/usr/bin/env bash

get_project_name_from_github_url() {
    local sContent sProject sUrl

    readonly sContent="${1?One parameter required: <content>}"

    readonly sUrl=$(echo "${sContent}" | grep -E '^SOURCE=' | grep -oE 'https?://.*')
    readonly sProject="$(echo "${sUrl}" | rev | grep -oE '[^/]+/[^/]+' | rev)"

    echo "${sProject}"
}
