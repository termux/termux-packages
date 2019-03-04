#!/bin/bash
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

set -e

TERMUX_PACKAGES_BASEDIR=$(realpath "$(dirname "$0")/../")
if [ ! -d "$TERMUX_PACKAGES_BASEDIR/packages" ]; then
    echo "[!] Cannot find directory 'packages'." >&2
    exit 1
fi

# In this variable a package metadata will be stored.
declare -gA PACKAGE_METADATA

# Initialize default configuration.
DEBFILES_DIR_PATH="$TERMUX_PACKAGES_BASEDIR/debs"
PACKAGE_DELETE_MODE=false

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

json_metadata_dump() {
    local pkg_licenses

    SAVEIFS=$IFS; IFS=",";
    for license in ${PACKAGE_METADATA['LICENSES']}; do
        pkg_licenses+="\"$(echo "${license}" | sed -r 's/^\s*(\S+(\s+\S+)*)\s*$/\1/')\","
    done
    pkg_licenses=${pkg_licenses%%,}; IFS=$SAVEIFS;

cat << EOF
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

delete_package() {
    local package_name=$1
    local curl_response
    local http_status_code
    local api_response_message

    echo -n "[@] Deleting published package '$package_name' from remote... " >&2
    curl_response=$(
        curl \
            --silent \
            --user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
            --request DELETE \
            --write-out "|%{http_code}" \
            "https://api.bintray.com/packages/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${package_name}"
    )

    http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
    api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

    case "$http_status_code" in
        200)
            echo "done" >&2
            ;;
        404)
            echo "no-need" >&2
            ;;
        *)
            echo "failure" >&2
            echo "[!] $api_response_message" >&2
            exit 1
            ;;
    esac
}

upload_package() {
    local package_name=$1
    local http_status_code
    local api_response_message
    declare -A debfiles_catalog

    for arch in all aarch64 arm i686 x86_64; do
        # Regular package.
        debfiles_catalog["${package_name}_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb"]=${arch}

        # Development package.
        debfiles_catalog["${package_name}-dev_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb"]=${arch}

        # Discover subpackages.
        for file in $(find "$TERMUX_PACKAGES_BASEDIR/packages/$package_name" -maxdepth 1 -type f -iname \*.subpackage.sh | sort); do
            file=$(basename "$file")
            debfiles_catalog["${file%%.subpackage.sh}_${PACKAGE_METADATA['VERSION_FULL']}_${arch}.deb"]=${arch}
        done

        unset debfiles
    done

    # Filter out nonexistent files.
    for item in "${!debfiles_catalog[@]}"; do
        if [ ! -f "$DEBFILES_DIR_PATH/$item" ]; then
            unset debfiles_catalog["$item"]
        fi
    done

    # Verify that our catalog is not empty.
    if [ ${#debfiles_catalog[@]} -eq 0 ]; then
        echo "[!] No *.deb files to upload." >&2
        exit 1
    fi

    # Delete entry for package (with all related debfiles).
    delete_package "$package_name"

    # Create new entry for package.
    echo -n "[@] Creating new entry for package '$package_name'... " >&2
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

    case "$http_status_code" in
        201)
            echo "done" >&2
            ;;
        409)
            echo "unchanged" >&2
            ;;
        *)
            echo "failure" >&2
            echo "[!] $api_response_message" >&2
            exit 1
            ;;
    esac

    for item in "${!debfiles_catalog[@]}"; do
        local package_arch=${debfiles_catalog[$item]}

        echo -n "[*]   Uploading '$item'... " >&2
        curl_response=$(
            curl \
                --silent \
                --user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
                --request PUT \
                --header "X-Bintray-Debian-Distribution: $BINTRAY_REPO_DISTRIBUTION" \
                --header "X-Bintray-Debian-Component: $BINTRAY_REPO_COMPONENT" \
                --header "X-Bintray-Debian-Architecture: $package_arch" \
                --header "X-Bintray-Package: ${package_name}" \
                --header "X-Bintray-Version: ${PACKAGE_METADATA['VERSION_FULL']}" \
                --upload-file "$DEBFILES_DIR_PATH/$item" \
                --write-out "|%{http_code}" \
                "https://api.bintray.com/content/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${package_arch}/${item}"
        )

        http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
        api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

        case "$http_status_code" in
            201)
                echo "done" >&2
                ;;
            409)
                echo "unchanged" >&2
                ;;
            *)
                echo "failure" >&2
                echo "[!] $api_response_message" >&2
                exit 1
                ;;
        esac
    done

    # Publishing package only after uploading all it's files. This will prevent
    # spawning multiple metadata-generation jobs and will allow to sign metadata
    # with maintainer's key.
    echo -n "[@] Publishing package '$package_name'... " >&2
    curl_response=$(
        curl \
            --silent \
            --user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
            --request POST \
            --header "Content-Type: application/json" \
            --data "{\"subject\":\"${BINTRAY_GPG_SUBJECT}\",\"passphrase\":\"$BINTRAY_GPG_PASSPHRASE\"}" \
            --write-out "|%{http_code}" \
            "https://api.bintray.com/content/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${package_name}/${PACKAGE_METADATA['VERSION_FULL']}/publish"
    )

    http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
    api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

    case "$http_status_code" in
        200)
            echo "done" >&2
            ;;
        *)
            echo "failure" >&2
            echo "[!] $api_response_message" >&2
            exit 1
            ;;
    esac
}

extract_variable_from_buildsh() {
    local extracted_value
    local variable_name
    variable_name=$1

    extracted_value=$(
        set -o noglob

        # When sourcing external code, do not expose variables
        # with sensitive information.
        unset BINTRAY_API_KEY
        unset BINTRAY_GPG_PASSPHRASE
        unset BINTRAY_GPG_SUBJECT
        unset BINTRAY_SUBJECT
        unset BINTRAY_USERNAME

        [ -e "$TERMUX_PACKAGES_BASEDIR/scripts/properties.sh" ] && . "$TERMUX_PACKAGES_BASEDIR/scripts/properties.sh"
        . "$TERMUX_PACKAGES_BASEDIR/packages/$package_name/build.sh"
        echo "${!variable_name}"
        set +o noglob
    )

    echo "$extracted_value"
}

process_packages() {
    local package_name
    local buildsh_path

    for package_name in "$@"; do
        buildsh_path="$TERMUX_PACKAGES_BASEDIR/packages/$package_name/build.sh"

        if [ -f "$buildsh_path" ]; then
            PACKAGE_METADATA["NAME"]="$package_name"

            PACKAGE_METADATA["LICENSES"]=$(extract_variable_from_buildsh "TERMUX_PKG_LICENSE" "$buildsh_path")
            if [ -z "${PACKAGE_METADATA['LICENSES']}" ]; then
                echo "[!] Mandatory field 'TERMUX_PKG_LICENSE' of package '$package_name' is empty." >&2
                exit 1
            fi

            PACKAGE_METADATA["DESCRIPTION"]=$(extract_variable_from_buildsh "TERMUX_PKG_DESCRIPTION" "$buildsh_path")
            if [ -z "${PACKAGE_METADATA['DESCRIPTION']}" ]; then
                echo "[!] Mandatory field 'TERMUX_PKG_DESCRIPTION' of package '$package_name' is empty." >&2
                exit 1
            fi

            PACKAGE_METADATA["WEBSITE_URL"]=$(extract_variable_from_buildsh "TERMUX_PKG_HOMEPAGE" "$buildsh_path")
            if [ -z "${PACKAGE_METADATA['WEBSITE_URL']}" ]; then
                echo "[!] Mandatory field 'TERMUX_PKG_HOMEPAGE' of package '$package_name' is empty." >&2
                exit 1
            fi

            PACKAGE_METADATA["VERSION"]=$(extract_variable_from_buildsh "TERMUX_PKG_VERSION" "$buildsh_path")
            if [ -z "${PACKAGE_METADATA['VERSION']}" ]; then
                echo "[!] Mandatory field 'TERMUX_PKG_VERSION' of package '$package_name' is empty." >&2
                exit 1
            fi

            PACKAGE_METADATA["REVISION"]=$(extract_variable_from_buildsh "TERMUX_PKG_REVISION" "$buildsh_path")
            if [ -n "${PACKAGE_METADATA['REVISION']}" ]; then
                PACKAGE_METADATA["VERSION_FULL"]="${PACKAGE_METADATA['VERSION']}-${PACKAGE_METADATA['REVISION']}"
            else
                if [ "${PACKAGE_METADATA['VERSION']}" != "${PACKAGE_METADATA['VERSION']/-/}" ]; then
                    PACKAGE_METADATA["VERSION_FULL"]="${PACKAGE_METADATA['VERSION']}-0"
                else
                    PACKAGE_METADATA["VERSION_FULL"]="${PACKAGE_METADATA['VERSION']}"
                fi
            fi
        else
            echo "[!] Cannot find 'build.sh' for package '$package_name'." >&2
            exit 1
        fi

        if $PACKAGE_DELETE_MODE; then
            delete_package "$package_name"
        else
            upload_package "$package_name"
        fi
    done

    # In deletion mode we need to do metadata recalculation separately
    # to ensure that it will be signed with maintainer's key.
    if $PACKAGE_DELETE_MODE; then
        local curl_response
        local http_status_code
        local api_response_message

        echo -n "[@] Requesting metadata recalculation... " >&2
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
                echo "done" >&2
                ;;
            *)
                echo "failure" >&2
                echo "[!] $api_response_message" >&2
                ;;
        esac
    fi
}

show_usage() {
    {
        echo
        echo "Usage: bintray-add-package.sh [OPTIONS] [package name] ..."
        echo
        echo "Package uploader script for Bintray."
        echo
        echo "Options:"
        echo
        echo "  -d, --delete       Delete package instead of uploading."
        echo
        echo "  -h, --help         Print this help."
        echo
        echo "  -p, --path [path]  Override path to directory with"
        echo "                     the *.deb files."
        echo
        echo "Credentials are specified via environment variables:"
        echo
        echo "  BINTRAY_USERNAME        - User name."
        echo "  BINTRAY_API_KEY         - User's API key."
        echo "  BINTRAY_GPG_SUBJECT     - Owner of GPG key."
        echo "  BINTRAY_GPG_PASSPHRASE  - GPG key passphrase."
        echo
    } >&2
}

###################################################################

while getopts ":-:hdp:" opt; do
    case "$opt" in
        -)
            case "$OPTARG" in
                delete)
                    PACKAGE_DELETE_MODE=true
                    ;;
                help)
                    show_usage
                    exit 0
                    ;;
                path)
                    DEBFILES_DIR_PATH="${!OPTIND}"
                    OPTIND=$((OPTIND + 1))

                    if [ -z "$DEBFILES_DIR_PATH" ]; then
                        echo "[!] Option '--${OPTARG}' requires argument." >&2
                        show_usage
                        exit 1
                    fi

                    if [ ! -d "$DEBFILES_DIR_PATH" ]; then
                        echo "[!] Directory '$DEBFILES_DIR_PATH' is not exist." >&2
                        show_usage
                        exit 1
                    fi
                    ;;
                *)
                    echo "[!] Invalid option '$OPTARG'." >&2
                    show_usage
                    exit 1
                    ;;
            esac
            ;;
        d)
            PACKAGE_DELETE_MODE=true
            ;;
        h)
            show_usage
            exit 0
            ;;
        p)
            DEBFILES_DIR_PATH="${OPTARG}"
            if [ ! -d "$DEBFILES_DIR_PATH" ]; then
                echo "[!] Directory '$DEBFILES_DIR_PATH' is not exist." >&2
                show_usage
                exit 1
            fi
            ;;
        *)
            echo "[!] Invalid option '-${OPTARG}'." >&2
            show_usage
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

if [ $# -gt 0 ]; then
    # These variables should never be changed.
    readonly DEBFILES_DIR_PATH
    readonly PACKAGE_DELETE_MODE
    readonly TERMUX_PACKAGES_BASEDIR

    # Without Bintray credentials this script is useless.
    if [ -z "$BINTRAY_USERNAME" ]; then
        echo "[!] Variable 'BINTRAY_USERNAME' is not set." >&2
        exit 1
    fi
    if [ -z "$BINTRAY_API_KEY" ]; then
        echo "[!] Variable 'BINTRAY_API_KEY' is not set." >&2
        exit 1
    fi
    if [ -z "$BINTRAY_GPG_SUBJECT" ]; then
        echo "[!] Variable 'BINTRAY_GPG_SUBJECT' is not set." >&2
        exit 1
    fi

    process_packages "$@"
    exit 0
else
    echo "[!] No packages specified." >&2
    show_usage
    exit 1
fi
