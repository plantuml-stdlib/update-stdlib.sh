#!/usr/bin/env bash

check_source_for_update() {
    local sContent sLocalVersion sProject sRemoteVersion

    readonly sContent="${1?One parameter required: <content>}"
    readonly sLocalVersion="$(get_local_version "${sContent}")"
    readonly sProject="$(get_project_name_from_github_url "${sContent}")"

    echo -n "${RESET_TEXT} =====> ${TEXT_BOLD}${sProject}${RESET_TEXT} (${COLOR_BLUE}${sLocalVersion}${RESET_TEXT})"

    readonly sRemoteVersion="$(get_version_from_remote_git "${sProject}")"

    echo " $(compare_versions "${sLocalVersion}" "${sRemoteVersion}")"
}
