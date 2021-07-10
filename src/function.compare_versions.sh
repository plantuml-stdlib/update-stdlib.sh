#!/usr/bin/env bash

compare_versions() {
    local sLocalVersion sRemoteVersion sResponse

    readonly sLocalVersion="${1?Two parameters required: <local-version> <remote-version>}"
    sRemoteVersion="${2?Two parameters required: <local-version> <remote-version>}"

    if [[ "${sLocalVersion}" == "" ]] || [[ "${sRemoteVersion}" == "" ]];then
        readonly sResponse="${COLOR_RED}No version infromation available${RESET_TEXT}"
    else
        if echo "${sRemoteVersion}" | grep --quiet -E '^[0-9]+\.[0-9]+$';then
            # Pad "x.y" format to "x.y.z" format
            sRemoteVersion="${sRemoteVersion}.0"
        fi

        if [[ "$(echo -e "${sRemoteVersion}\n${sLocalVersion}" | sort -V | tail -n 1)" == "${sLocalVersion}" ]];then
            readonly sResponse="${COLOR_GREEN}Up To Date${RESET_TEXT}"
        else
            readonly sResponse="${COLOR_YELLOW}Newer version available ${TEXT_INVERSE} ${sRemoteVersion} ${RESET_TEXT}"
        fi
    fi

    echo "${sResponse}"
}
