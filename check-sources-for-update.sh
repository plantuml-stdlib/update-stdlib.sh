#!/usr/bin/env bash

set -o errexit -o errtrace -o nounset -o pipefail

# ==============================================================================
: readonly "${RESET_TEXT:=$(tput sgr0)}"      # turn off all attributes
# ------------------------------------------------------------------------------
# Foreground colors
# ------------------------------------------------------------------------------
: readonly "${COLOR_BLUE:=$(tput setaf 4)}"
: readonly "${COLOR_GREEN:=$(tput setaf 2)}"
: readonly "${COLOR_RED:=$(tput setaf 1)}"
: readonly "${COLOR_WHITE:=$(tput setaf 7)}"
: readonly "${COLOR_YELLOW:=$(tput setaf 3)}"
# ------------------------------------------------------------------------------
# Text attributes
# ------------------------------------------------------------------------------
: readonly "${TEXT_BOLD:=$(tput bold)}"       # turn on bold (extra bright) mode
: readonly "${TEXT_INVERSE:=$(tput rev)}"     # turn on color inverse mode
# ------------------------------------------------------------------------------
# Text output channels
# ------------------------------------------------------------------------------
: "${ERROR_OUTPUT:=/dev/stderr}"
: "${NORMAL_OUTPUT:=/dev/stdout}"
: "${SILENCE_OUTPUT:=/dev/null}"
# ==============================================================================

: "${GIT:=git}"

check_sources_for_update() {

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

    get_project_name_from_github_url() {
        local sContent sProject sUrl

        readonly sContent="${1?One parameter required: <content>}"

        readonly sUrl=$(echo "${sContent}" | grep -E '^SOURCE=' | grep -oE 'https?://.*')
        readonly sProject="$(echo "${sUrl}" | rev | grep -oE '[^/]+/[^/]+' | rev)"

        echo "${sProject}"
    }

    check_source_for_update() {
        local sContent sLocalVersion sProject sRemoteVersion

        readonly sContent="${1?One parameter required: <content>}"
        readonly sLocalVersion="$(get_local_version "${sContent}")"
        readonly sProject="$(get_project_name_from_github_url "${sContent}")"

        echo -n "${RESET_TEXT} =====> ${TEXT_BOLD}${sProject}${RESET_TEXT} (${COLOR_BLUE}${sLocalVersion}${RESET_TEXT})"

        readonly sRemoteVersion="$(get_version_from_remote_git "${sProject}")"

        echo " $(compare_versions "${sLocalVersion}" "${sRemoteVersion}")"
    }

    run() {
        local sSourcesFile sSourcePaths

        sSourcePaths="${1?One parameter required: <sources-path>}"

        for sSourcesFile in "${sSourcePaths}/"*'/INFO';do
            check_source_for_update "$(cat "${sSourcesFile}")"
        done;

        # @TODO: Move this to an exit trap, so we don't fuck up the terminal when a user aborts
        echo -n "${RESET_TEXT}"
    }

    run "${@}"
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f check_sources_for_update
else
  check_sources_for_update "${@}"
  exit $?
fi
