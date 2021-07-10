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

    local -r sScriptPath="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

    # shellcheck source=./src/function.check_source_for_update.sh
    source "${sScriptPath}/src/function.check_source_for_update.sh"
    # shellcheck source=./src/function.compare_versions.sh
    source "${sScriptPath}/src/function.compare_versions.sh"
    # shellcheck source=./src/function.get_local_version.sh
    source "${sScriptPath}/src/function.get_local_version.sh"
    # shellcheck source=./src/function.get_project_name_from_github_url.sh
    source "${sScriptPath}/src/function.get_project_name_from_github_url.sh"
    # shellcheck source=./src/function.get_version_from_remote_git.sh
    source "${sScriptPath}/src/function.get_version_from_remote_git.sh"

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
