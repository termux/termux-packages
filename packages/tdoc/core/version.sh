#!/usr/bin/env bash

export TDOC_NAME="TDOC (Termux Doctor)"
export TDOC_VERSION="1.0.5"
export TDOC_CODENAME="Stabilization"
export TDOC_BUILD_DATE="$(date '+%Y-%m-%d')"

# Optional helper function to display version info in CLI
tdoc_version_ui() {
    BOLD="\e[1m"
    DIM="\e[2m"
    CYAN="\e[36m"
    GREEN="\e[32m"
    RESET="\e[0m"
    ICON_INFO="ℹ"

    # Header
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}${CYAN}🛰 TDOC — Version Info${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

    # Details
    echo -e "${GREEN}Name    : ${TDOC_NAME}${RESET}"
    echo -e "${GREEN}Version : ${TDOC_VERSION}${RESET}"
    echo -e "${GREEN}Codename: ${TDOC_CODENAME}${RESET}"
    echo -e "${GREEN}Build   : ${TDOC_BUILD_DATE}${RESET}"

    # Hint
    echo -e "\n${DIM}${ICON_INFO} Run 'tdoc help' for usage${RESET}"
}
