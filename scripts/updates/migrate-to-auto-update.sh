#!/usr/bin/env bash
set -e -u
BASEDIR=$(dirname "$(realpath "$0")")

if [ -f "${BASEDIR}/github-projects.txt" ]; then
	for line in $(grep -P '^[a-z0-9]' "${BASEDIR}/github-projects.txt"); do
        package=$(echo "$line" | cut -d'|' -f1)
		project=$(echo "$line" | cut -d'|' -f2)
		version_regexp=$(echo "$line" | cut -d'|' -f3-)

		if [ ! -d "${BASEDIR}/../../packages/${package}" ]; then
			echo "Package '$package' is not available, skipping."
			continue
		fi

		auto_update_flag=$(set +e +u; . "${BASEDIR}/../../packages/${package}/build.sh" 2>/dev/null; echo "$TERMUX_PKG_AUTO_UPDATE";)

		if [ -n "${auto_update_flag}" ]; then
			# Already migrated.
			continue
		fi

        sed -i "/^TERMUX_PKG_SRCURL=/a\TERMUX_PKG_AUTO_UPDATE=true" "${BASEDIR}/../../packages/${package}/build.sh"
        if [ -n "$version_regexp" ]; then
            sed -i "/^TERMUX_PKG_AUTO_UPDATE=/a\TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP=\"${version_regexp//\\/\\\\}\"" "${BASEDIR}/../../packages/${package}/build.sh"
        fi
    done
fi