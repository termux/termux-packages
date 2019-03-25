#!/usr/bin/env bash
##
##  Package uploader for Bintray.
##
##  Leonid Plyushch <leonid.plyushch@gmail.com> (C) 2019
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

set -o errexit
set -o nounset

TERMUX_PACKAGES_BASEDIR=$(realpath "$(dirname "$0")/../")

# Verify that script is correctly installed to Termux repository.
if [ ! -d "$TERMUX_PACKAGES_BASEDIR/packages" ]; then
	echo "[!] Cannot find directory 'packages'."
	exit 1
fi

# Check dependencies.
if [ -z "$(command -v curl)" ]; then
	echo "[!] Package 'curl' is not installed."
	exit 1
fi
if [ -z "$(command -v find)" ]; then
	echo "[!] Package 'findutils' is not installed."
	exit 1
fi
if [ -z "$(command -v grep)" ]; then
	echo "[!] Package 'grep' is not installed."
	exit 1
fi
if [ -z "$(command -v jq)" ]; then
	echo "[!] Package 'jq' is not installed."
	exit 1
fi

###################################################################

# In this variable a package metadata will be stored.
declare -gA PACKAGE_METADATA

# Initialize default configuration.
DEBFILES_DIR_PATH="$TERMUX_PACKAGES_BASEDIR/debs"
METADATA_GEN_MODE=false
PACKAGE_CLEANUP_MODE=false
PACKAGE_DELETION_MODE=false
SCRIPT_EMERG_EXIT=false

# Bintray-specific configuration.
BINTRAY_REPO_NAME="termux-packages-24"
BINTRAY_REPO_GITHUB="termux/termux-packages"
BINTRAY_REPO_DISTRIBUTION="stable"
BINTRAY_REPO_COMPONENT="main"

# Bintray credentials that should be set as external environment
# variables by user.
: "${BINTRAY_USERNAME:=""}"
: "${BINTRAY_API_KEY:=""}"
: "${BINTRAY_GPG_SUBJECT:=""}"
: "${BINTRAY_GPG_PASSPHRASE:=""}"

# If BINTRAY_GPG_SUBJECT is not specified, then signing will be
# done with gpg key of subject '$BINTRAY_USERNAME'.
if [ -z "$BINTRAY_GPG_SUBJECT" ]; then
	BINTRAY_GPG_SUBJECT="$BINTRAY_USERNAME"
fi

# Packages are built and uploaded for Termux organisation.
BINTRAY_SUBJECT="termux"

###################################################################

## Print message to stderr.
## Takes same arguments as command 'echo'.
msg() {
	echo "$@" >&2
}


## Blocks terminal to prevent any user input.
## Takes no arguments.
block_terminal() {
	stty -echo -icanon time 0 min 0 2>/dev/null || true
	stty quit undef susp undef 2>/dev/null || true
}


## Unblocks terminal blocked with block_terminal() function.
## Takes no arguments.
unblock_terminal() {
	while read -r; do
		true;
	done
	stty sane 2>/dev/null || true
}


## Process request for aborting script execution.
## Used by signal trap.
## Takes no arguments.
request_emerg_exit() {
	SCRIPT_EMERG_EXIT=true
}


## Handle emergency exit requested by ctrl-c.
## Takes no arguments.
emergency_exit() {
	msg
	recalculate_metadata
	msg "[!] Aborted by user."
	unblock_terminal
	exit 1
}


## Dump everything from $PACKAGE_METADATA to json structure.
## Takes no arguments.
json_metadata_dump() {
	local old_ifs=$IFS
	local license
	local pkg_licenses

	IFS=","
	for license in ${PACKAGE_METADATA['LICENSES']}; do
		pkg_licenses+="\"$(echo "$license" | sed -r 's/^\s*(\S+(\s+\S+)*)\s*$/\1/')\","
	done
	pkg_licenses=${pkg_licenses%%,}
	IFS=$old_ifs

	cat <<- EOF
	{
	    "name": "${PACKAGE_METADATA['NAME']}",
	    "desc": "${PACKAGE_METADATA['DESCRIPTION']}",
	    "version": "${PACKAGE_METADATA['VERSION_FULL']}",
	    "licenses": [${pkg_licenses}],
	    "vcs_url": "https://github.com/${BINTRAY_REPO_GITHUB}",
	    "website_url": "${PACKAGE_METADATA['WEBSITE_URL']}",
	    "issue_tracker_url": "https://github.com/${BINTRAY_REPO_GITHUB}/issues",
	    "github_repo": "${BINTRAY_REPO_GITHUB}",
	    "public_download_numbers": "true",
	    "public_stats": "false"
	}
	EOF
}


## Request metadata recalculation and signing.
## Takes no arguments.
recalculate_metadata() {
	local curl_response
	local http_status_code
	local api_response_message

	msg -n "[@] Requesting metadata recalculation... "
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request POST \
			--header "Content-Type: application/json" \
			--data "{\"subject\":\"${BINTRAY_GPG_SUBJECT}\",\"passphrase\":\"$BINTRAY_GPG_PASSPHRASE\"}" \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/calc_metadata/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/"
	)

	http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
	api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

	case "$http_status_code" in
		202)
			msg "done"
			;;
		*)
			msg "failure"
			msg "[!] $api_response_message"
			;;
	esac
}


## Request deletion of the specified package.
## Takes only one argument - package name.
delete_package() {
	msg -n "   * ${1}: "

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	local curl_response
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request DELETE \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/packages/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${1}"
	)

	local http_status_code
	http_status_code=$(
		echo "$curl_response" | cut -d'|' -f2
	)

	local api_response_message
	api_response_message=$(
		echo "$curl_response" | cut -d'|' -f1 | jq -r .message
	)

	if [ "$http_status_code" = "200" ] || [ "$http_status_code" = "404" ]; then
		msg "success"
	else
		msg "$api_response_message"
	fi

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi
}


## Leave only the latest version of specified package and remove old ones.
## Takes only one argument - package name.
delete_old_versions_from_package() {
	local package_versions
	local package_latest_version
	local curl_response
	local http_status_code
	local api_response_message

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	msg -n "    * ${1}: checking latest version... "
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request GET \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/packages/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${1}"
	)

	http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
	api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

	if [ "$http_status_code" = "200" ]; then
		package_latest_version=$(
			echo "$curl_response" | cut -d'|' -f1 | jq -r .latest_version | \
				sed 's/\./\\./g'
		)

		package_versions=$(
			echo "$curl_response" | cut -d'|' -f1 | jq -r '.versions[]' | \
				grep -v "^$package_latest_version$" || true
		)
	else
		msg "$api_response_message."
		return 1
	fi

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	if [ -n "$package_versions" ]; then
		local old_version
		for old_version in $package_versions; do
			if $SCRIPT_EMERG_EXIT; then
				emergency_exit
			fi

			msg -ne "\\r\\e[2K    * ${1}: deleting '$old_version'... "
			curl_response=$(
				curl \
					--silent \
					--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
					--request DELETE \
					--write-out "|%{http_code}" \
					"https://api.bintray.com/packages/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${1}/versions/${old_version}"
			)

			http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
			api_response_message=$(
				echo "$curl_response" | cut -d'|' -f1 | jq -r .message
			)

			if [ "$http_status_code" != "200" ] && [ "$http_status_code" != "404" ]; then
				msg "$api_response_message"
				return 1
			fi

			if $SCRIPT_EMERG_EXIT; then
				emergency_exit
			fi
		done
	fi

	msg -e "\\r\\e[2K    * ${1}: success"
}


## Upload the specified package. Will also create a new version entry
## if required. When upload is done within the same version, already existing
## *.deb files will not be replaced.
##
## Note that upload_package() detects right *.deb files by using naming scheme
## defined in the build script. It does not care about actual content stored in
## the package so the good advice is to never rename *.deb files once they built.
##
## Function takes only one argument - package name.
upload_package() {
	local curl_response
	local http_status_code
	local api_response_message

	declare -A debfiles_catalog

	local arch
	for arch in all aarch64 arm i686 x86_64; do
		# Regular package.
		if [ -f "$DEBFILES_DIR_PATH/${1}_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb" ]; then
			debfiles_catalog["${1}_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb"]=${arch}
		fi

		# Development package.
		if [ -f "$DEBFILES_DIR_PATH/${1}-dev_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb" ]; then
			debfiles_catalog["${1}-dev_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb"]=${arch}
		fi

		# Discover subpackages.
		local file
		for file in $(find "$TERMUX_PACKAGES_BASEDIR/packages/${1}/" -maxdepth 1 -type f -iname \*.subpackage.sh | sort); do
			file=$(basename "$file")

			if [ -f "$DEBFILES_DIR_PATH/${file%%.subpackage.sh}_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb" ]; then
				debfiles_catalog["${file%%.subpackage.sh}_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb"]=${arch}
			fi
		done
	done

	# Verify that our catalog is not empty.
	set +o nounset
	if [ ${#debfiles_catalog[@]} -eq 0 ]; then
		set -o nounset
		msg "    * ${1}: skipping because no files to upload."
		return 1
	fi
	set -o nounset

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	# Create new entry for package.
	msg -n "    * ${1}: creating entry for version '${PACKAGE_METADATA['VERSION_FULL']}'... "
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request POST \
			--header "Content-Type: application/json" \
			--data "$(json_metadata_dump)" \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/packages/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}"
	)

	http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
	api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

	if [ "$http_status_code" != "201" ] && [ "$http_status_code" != "409" ]; then
		msg "$api_response_message"
		return 1
	fi

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	for item in "${!debfiles_catalog[@]}"; do
		local package_arch=${debfiles_catalog[$item]}

		if $SCRIPT_EMERG_EXIT; then
			emergency_exit
		fi

		msg -ne "\\r\\e[2K    * ${1}: uploading '$item'... "
		curl_response=$(
			curl \
				--silent \
				--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
				--request PUT \
				--header "X-Bintray-Debian-Distribution: $BINTRAY_REPO_DISTRIBUTION" \
				--header "X-Bintray-Debian-Component: $BINTRAY_REPO_COMPONENT" \
				--header "X-Bintray-Debian-Architecture: $package_arch" \
				--header "X-Bintray-Package: ${1}" \
				--header "X-Bintray-Version: ${PACKAGE_METADATA['VERSION_FULL']}" \
				--upload-file "$DEBFILES_DIR_PATH/$item" \
				--write-out "|%{http_code}" \
				"https://api.bintray.com/content/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${package_arch}/${item}"
		)

		http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
		api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

		if [ "$http_status_code" != "201" ] && [ "$http_status_code" != "409" ]; then
			msg "$api_response_message"
			return 1
		fi

		if $SCRIPT_EMERG_EXIT; then
			emergency_exit
		fi
	done

	# Publishing package only after uploading all it's files. This will prevent
	# spawning multiple metadata-generation jobs and will allow to sign metadata
	# with maintainer's key.
	msg -ne "\\r\\e[2K    * ${1}: publishing... "
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request POST \
			--header "Content-Type: application/json" \
			--data "{\"subject\":\"${BINTRAY_GPG_SUBJECT}\",\"passphrase\":\"$BINTRAY_GPG_PASSPHRASE\"}" \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/content/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${1}/${PACKAGE_METADATA['VERSION_FULL']}/publish"
	)

	http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
	api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

	if [ "$http_status_code" = "200" ]; then
		msg -e "\\r\\e[2K    * ${1}: success"
	else
		msg "$api_response_message"
		return 1
	fi
}


## Extact value of specified variable from build.sh script.
## Takes 2 arguments: package name, variable name.
get_package_property() {
	local buildsh_path="$TERMUX_PACKAGES_BASEDIR/packages/$1/build.sh"
	local extracted_value

	extracted_value=$(
		set +o nounset
		set -o noglob

		# When sourcing external code, do not expose variables
		# with sensitive information.
		unset BINTRAY_API_KEY
		unset BINTRAY_GPG_PASSPHRASE
		unset BINTRAY_GPG_SUBJECT
		unset BINTRAY_SUBJECT
		unset BINTRAY_USERNAME

		if [ -e "$TERMUX_PACKAGES_BASEDIR/scripts/properties.sh" ]; then
			. "$TERMUX_PACKAGES_BASEDIR/scripts/properties.sh" 2>/dev/null
		fi

		. "$buildsh_path" 2>/dev/null

		echo "${!2}"

		set +o noglob
		set -o nounset
	)

	echo "$extracted_value"
}


## Execute desired action on specified packages.
## Takes arbitrary amount of arguments - package names.
process_packages() {
	local package_name
	local package_name_list
	local buildsh_path

	if $PACKAGE_CLEANUP_MODE; then
		msg "[@] Removing old versions:"
	elif $PACKAGE_DELETION_MODE; then
		msg "[@] Deleting packages from remote:"
	elif $METADATA_GEN_MODE; then
		recalculate_metadata
		msg "[@] Finished."
		return 0
	else
		msg "[@] Uploading packages:"
	fi
	msg

	block_terminal

	# Remove duplicates from the list of the package names.
	readarray -t package_name_list < <(printf '%s\n' "${@}" | sort -u)

	for package_name in "${package_name_list[@]}"; do
		if $SCRIPT_EMERG_EXIT; then
			emergency_exit
		fi

		if $PACKAGE_DELETION_MODE; then
			delete_package "$package_name" || continue
		else
			if [ ! -f "$TERMUX_PACKAGES_BASEDIR/packages/$1/build.sh" ]; then
				msg "    * ${package_name}: skipping because such package does not exist."
				continue
			fi

			PACKAGE_METADATA["NAME"]="$package_name"

			PACKAGE_METADATA["LICENSES"]=$(get_package_property "$package_name" "TERMUX_PKG_LICENSE")
			if [ -z "${PACKAGE_METADATA['LICENSES']}" ]; then
				msg "    * ${package_name}: skipping because field 'TERMUX_PKG_LICENSE' is empty."
				continue
			elif grep -qP '.*custom.*' <(echo "${PACKAGE_METADATA['LICENSES']}"); then
				msg "    * ${package_name}: skipping because it has custom license."
				continue
			fi

			PACKAGE_METADATA["DESCRIPTION"]=$(get_package_property "$package_name" "TERMUX_PKG_DESCRIPTION")
			if [ -z "${PACKAGE_METADATA['DESCRIPTION']}" ]; then
				msg "    * ${package_name}: skipping because field 'TERMUX_PKG_DESCRIPTION' is empty."
				continue
			fi

			PACKAGE_METADATA["WEBSITE_URL"]=$(get_package_property "$package_name" "TERMUX_PKG_HOMEPAGE")
			if [ -z "${PACKAGE_METADATA['WEBSITE_URL']}" ]; then
				msg "    * ${package_name}: skipping because field 'TERMUX_PKG_HOMEPAGE' is empty."
				continue
			fi

			PACKAGE_METADATA["VERSION"]=$(get_package_property "$package_name" "TERMUX_PKG_VERSION")
			if [ -z "${PACKAGE_METADATA['VERSION']}" ]; then
				msg "    * ${package_name}: skipping because field 'TERMUX_PKG_VERSION' is empty."
				continue
			fi

			PACKAGE_METADATA["REVISION"]=$(get_package_property "$package_name" "TERMUX_PKG_REVISION")
			if [ -n "${PACKAGE_METADATA['REVISION']}" ]; then
				PACKAGE_METADATA["VERSION_FULL"]="${PACKAGE_METADATA['VERSION']}-${PACKAGE_METADATA['REVISION']}"
			else
				if [ "${PACKAGE_METADATA['VERSION']}" != "${PACKAGE_METADATA['VERSION']/-/}" ]; then
					PACKAGE_METADATA["VERSION_FULL"]="${PACKAGE_METADATA['VERSION']}-0"
				else
					PACKAGE_METADATA["VERSION_FULL"]="${PACKAGE_METADATA['VERSION']}"
				fi
			fi

			if $PACKAGE_CLEANUP_MODE; then
				delete_old_versions_from_package "$package_name" || continue
			else
				upload_package "$package_name" || continue
			fi
		fi
	done

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	unblock_terminal

	msg
	if $PACKAGE_CLEANUP_MODE || $PACKAGE_DELETION_MODE; then
		recalculate_metadata
	fi
	msg "[@] Finished."
}


## Just print information about usage.
## Takes no arumnets.
show_usage() {
	msg
	msg "Usage: package_uploader.sh [OPTIONS] [package name] ..."
	msg
	msg "A command line client for Bintray designed for managing"
	msg "Termux *.deb packages."
	msg
	msg "=========================================================="
	msg
	msg "Primarily indended to be used by Gitlab CI for automatic"
	msg "package uploads but it can be used for manual uploads too."
	msg
	msg "Before using this script, check that you have all"
	msg "necessary credentials for accessing repository."
	msg
	msg "Credentials are specified via environment variables:"
	msg
	msg "  BINTRAY_USERNAME        - User name."
	msg "  BINTRAY_API_KEY         - User's API key."
	msg "  BINTRAY_GPG_SUBJECT     - Owner of GPG key."
	msg "  BINTRAY_GPG_PASSPHRASE  - GPG key passphrase."
	msg
	msg "=========================================================="
	msg
	msg "Options:"
	msg
	msg "  -h, --help         Print this help."
	msg
	msg "  -c, --cleanup      Action. Clean selected packages by"
	msg "                     removing older versions from the remote."
	msg
	msg "  -d, --delete       Action. Remove selected packages from"
	msg "                     remote."
	msg
	msg "  -r, --regenerate   Action. Request metadata recalculation"
	msg "                     and signing on the remote."
	msg
	msg
	msg "  -p, --path [path]  Specify a directory containing *.deb"
	msg "                     files ready for uploading."
	msg "                     Default is './debs'."
	msg
	msg "=========================================================="
}

###################################################################

trap request_emerg_exit INT

while getopts ":-:hcdrp:" opt; do
	case "$opt" in
		-)
			case "$OPTARG" in
				help)
					show_usage
					exit 0
					;;
				cleanup)
					PACKAGE_CLEANUP_MODE=true
					;;
				delete)
					PACKAGE_DELETION_MODE=true
					;;
				regenerate)
					METADATA_GEN_MODE=true;
					;;
				path)
					DEBFILES_DIR_PATH="${!OPTIND}"
					OPTIND=$((OPTIND + 1))

					if [ -z "$DEBFILES_DIR_PATH" ]; then
						msg "[!] Option '--${OPTARG}' requires argument."
						show_usage
						exit 1
					fi

					if [ ! -d "$DEBFILES_DIR_PATH" ]; then
						msg "[!] Directory '$DEBFILES_DIR_PATH' does not exist."
						show_usage
						exit 1
					fi
					;;
				*)
					msg "[!] Invalid option '$OPTARG'."
					show_usage
					exit 1
					;;
			esac
			;;
		h)
			show_usage
			exit 0
			;;
		c)
			PACKAGE_CLEANUP_MODE=true
			;;
		d)
			PACKAGE_DELETION_MODE=true
			;;
		r)
			METADATA_GEN_MODE=true
			;;
		p)
			DEBFILES_DIR_PATH="${OPTARG}"
			if [ ! -d "$DEBFILES_DIR_PATH" ]; then
				msg "[!] Directory '$DEBFILES_DIR_PATH' does not exist."
				show_usage
				exit 1
			fi
			;;
		*)
			msg "[!] Invalid option '-${OPTARG}'."
			show_usage
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

if [ $# -lt 1 ] && ! $METADATA_GEN_MODE; then
	msg "[!] No packages specified."
	show_usage
	exit 1
fi

# These variables should never be changed.
readonly DEBFILES_DIR_PATH
readonly PACKAGE_DELETION_MODE
readonly PACKAGE_CLEANUP_MODE
readonly TERMUX_PACKAGES_BASEDIR

# Check if no mutually exclusive options used.
if $PACKAGE_CLEANUP_MODE && $METADATA_GEN_MODE; then
	msg "[!] Options '-c|--cleanup' and '-r|--regenerate' are mutually exclusive."
	exit 1
fi
if $PACKAGE_CLEANUP_MODE && $PACKAGE_DELETION_MODE; then
	msg "[!] Options '-c|--cleanup' and '-d|--delete' are mutually exclusive."
	exit 1
fi
if $PACKAGE_DELETION_MODE && $METADATA_GEN_MODE; then
	msg "[!] Options '-d|--delete' and '-r|--regenerate' are mutually exclusive."
	exit 1
fi

# Without Bintray credentials this script is useless.
if [ -z "$BINTRAY_USERNAME" ]; then
	msg "[!] Variable 'BINTRAY_USERNAME' is not set."
	exit 1
fi
if [ -z "$BINTRAY_API_KEY" ]; then
	msg "[!] Variable 'BINTRAY_API_KEY' is not set."
	exit 1
fi
if [ -z "$BINTRAY_GPG_SUBJECT" ]; then
	msg "[!] Variable 'BINTRAY_GPG_SUBJECT' is not set."
	exit 1
fi

process_packages "$@"
exit 0
