TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/texinfo/
TERMUX_PKG_DESCRIPTION="Documentation system for on-line information and printed output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.2"
_DEBIAN_REVISION="-1"
TERMUX_PKG_SRCURL=(
	https://mirrors.kernel.org/gnu/texinfo/texinfo-${TERMUX_PKG_VERSION}.tar.xz
	https://deb.debian.org/debian/pool/main/t/texinfo/texinfo_${TERMUX_PKG_VERSION}${_DEBIAN_REVISION}.debian.tar.xz
)
TERMUX_PKG_SHA256=(
	0329d7788fbef113fa82cb80889ca197a344ce0df7646fe000974c5d714363a6
	1d0c8ad2a7614595b13e690a423505f10c90f4ede222d2915eab66de5aa51117
)
TERMUX_PKG_AUTO_UPDATE=true
# gawk is used by texindex:
TERMUX_PKG_DEPENDS="gawk, libiconv, ncurses, perl"
TERMUX_PKG_RECOMMENDS="update-info-dir"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-perl-xs
texinfo_cv_sys_iconv_converts_euc_cn=no
"

termux_pkg_auto_update() {
	# based on scripts/updates/api/termux_repology_api_get_latest_version.sh
	local TERMUX_REPOLOGY_DATA_FILE=$(mktemp)
	python3 "${TERMUX_SCRIPTDIR}"/scripts/updates/api/dump-repology-data \
		"${TERMUX_REPOLOGY_DATA_FILE}" "${TERMUX_PKG_NAME}" >/dev/null || \
		echo "{}" > "${TERMUX_REPOLOGY_DATA_FILE}"
	local latest_version=$(jq -r --arg packageName "${TERMUX_PKG_NAME}" '.[$packageName]' < "${TERMUX_REPOLOGY_DATA_FILE}")
	if [[ "${latest_version}" == "null" ]]; then
		latest_version="${TERMUX_PKG_VERSION}"
	fi
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		rm -f "${TERMUX_REPOLOGY_DATA_FILE}"
		return
	fi
	rm -f "${TERMUX_REPOLOGY_DATA_FILE}"

	local api_url=$(dirname "${TERMUX_PKG_SRCURL[1]}")
	local api_url_r=$(curl -sL "${api_url}")
	local api_url_r1=$(echo "${api_url_r}" | grep "texinfo_${latest_version}")
	local debian_revision=$(echo "${api_url_r1}" | sed -nE "s/.*>texinfo_${latest_version}(.*).debian.tar.xz<.*/\1/p")
	if [[ -z "${debian_revision}" ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		latest_version=${latest_version}
		api_url_r1=${api_url_r1}
		debian_revision=${debian_revision}
		EOL
		return
	fi
	local tmpdir=$(mktemp -d)
	curl -sLC- \
		"$(dirname "${TERMUX_PKG_SRCURL[0]}")/texinfo-${latest_version}.tar.xz" \
		-o "${tmpdir}/texinfo-${latest_version}.tar.xz"
	curl -sLC- \
		"$(dirname "${TERMUX_PKG_SRCURL[1]}")/texinfo_${latest_version}${debian_revision}.debian.tar.xz" \
		-o "${tmpdir}/texinfo_${latest_version}${debian_revision}.debian.tar.xz"
	local texinfo_txz_sha256=$(sha256sum "${tmpdir}/texinfo-${latest_version}.tar.xz" | sed -e "s| .*$||")
	local texinfo_debian_txz_sha256=$(sha256sum "${tmpdir}/texinfo_${latest_version}${debian_revision}.debian.tar.xz" | sed -e "s| .*$||")
	if [[ -z "${texinfo_txz_sha256}" || -z "${texinfo_debian_txz_sha256}" ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		texinfo_txz_sha256=${texinfo_txz_sha256}
		texinfo_debian_txz_sha256=${texinfo_debian_txz_sha256}
		EOL
		return
	fi

	sed \
		-e "s|^_DEBIAN_REVISION=.*|_DEBIAN_REVISION=\"${debian_revision}\"|" \
		-e "s|^\t${TERMUX_PKG_SHA256[0]}.*|\t${texinfo_txz_sha256}|" \
		-e "s|^\t${TERMUX_PKG_SHA256[1]}.*|\t${texinfo_debian_txz_sha256}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	rm -fr "${tmpdir}"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_make_install() {
	pushd "${TERMUX_PKG_SRCDIR}/debian"
	install -Dm755 -t $TERMUX_PREFIX/bin update-info-dir
	install -Dm644 -t $TERMUX_PREFIX/share/man/man8 update-info-dir.8
	popd
}
