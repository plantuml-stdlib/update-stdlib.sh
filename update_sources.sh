#!/usr/bin/env bash

set -o errexit -o errtrace -o nounset -o pipefail

update_sources() {

    get_project_name_from_github_url() {
        local sContent sProject sUrl

        readonly sContent="${1?One parameter required: <content>}"

        readonly sUrl=$(echo "${sContent}" | grep -E '^SOURCE=' | grep -oE 'https?://.*')
        readonly sProject="$(echo "${sUrl}" | rev | grep -oE '[^/]+/[^/]+' | rev)"

        echo "${sProject}"
    }

    update_source() {
        local iLength sConfig sFilePath sPath sProject sSource sSourceFile sSourcePath sTargetFile sTargetPath

        readonly sProject="${1?Five parameters required: <project> <target-path> <source-path> <path> <config>}"
        readonly sTargetPath="${2?Five parameters required: <project> <target-path> <source-path> <path> <config>}"
        readonly sSourcePath="${3?Five parameters required: <project> <target-path> <source-path> <path> <config>}"
        readonly sPath="${4?Five parameters required: <project> <target-path> <source-path> <path> <config>}"
        readonly sConfig="${5?Five parameters required: <project> <target-path> <source-path> <path> <config>}"

        echo -e "\n =====> Updating ${sProject} (${sPath})"

        if [[ ! -d "${sSourcePath}/${sPath}" ]];then
            echo ' -----> Creating git clone'
            git clone "git://github.com/${sProject}.git" "${sSourcePath}/${sPath}"
        else
            echo ' -----> Git clone exists, pull latest changes'
            git --git-dir="${sSourcePath}/${sPath}/.git" --work-tree="${sSourcePath}/${sPath}" pull
        fi

        echo ' -----> Looking up config'

        sSource="$(echo "${sConfig}" | grep "\b${sPath}\b" | tr -d ' ')" || true

        if [[ "${sSource}" == '' ]];then
            echo -e "\tNo config available. Skipping"
        else
            readonly iLength=$(( "${#sSourcePath} + ${#sSource}" + 1))
            echo ' -----> Copying "*.puml" files'

            find "${sSourcePath}/${sSource}" -name '*.puml' -print0 |
            while read -r -d $'\0' sFilePath; do
                sSourceFile="${sSourcePath}/${sSource}${sFilePath:${iLength}}"
                sTargetFile="${sTargetPath}/${sPath}/${sFilePath:${iLength}}"

                  sTargetFolder="$(dirname "${sTargetFile}")"

                  if [[ ! -d "${sTargetFolder}" ]];then
                      mkdir -p "${sTargetFolder}"
                  fi

                cp "${sSourceFile}" "${sTargetFile}"
            done
        fi
    }

    run() {
        local sConfigFile sContent sFolder sPath sProject sSourcesFile sSourcePath sTargetPath

        readonly sTargetPath="${1?Three parameters required: <target-path> <source-path> <config-file>}"
        readonly sSourcePath="${2?Three parameters required: <target-path> <source-path> <config-file>}"
        readonly sConfigFile="${3?Three parameters required: <target-path> <source-path> <config-file>}"

        for sSourcesFile in "${sTargetPath}/"*'/INFO';do
            sPath="$(dirname "${sSourcesFile}")"

            sFolder="$(basename "${sPath}")"

            sContent="$(cat "${sSourcesFile}")"

            sProject="$(get_project_name_from_github_url "${sContent}")"

            update_source                       \
                "${sProject}"                   \
                "$(realpath "${sTargetPath}")"  \
                "$(realpath "${sSourcePath}")"  \
                "${sFolder}"                    \
                "$(cat "${sConfigFile}")"
        done;

        # Cleanup
        rm -rf "${sTargetPath}/C4/samples/" "${sTargetPath}/tupadr3/examples/"
    }

    run "${@}"
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f update_sources
else
  update_sources "${@}"
  exit $?
fi
