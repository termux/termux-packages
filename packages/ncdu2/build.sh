TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdu
TERMUX_PKG_DESCRIPTION="Disk usage analyzer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSES/MIT.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6"
TERMUX_PKG_SRCURL=https://dev.yorhel.nl/download/ncdu-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3f471ebd38b56e60dab80c27e3af1d826666957f02d9e8419b149daaf7ade505
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# TODO drop all this once figure out how zig can work with bionic libc
	local -a deps=( 'ncurses' 'zstd' )
	for dep in "${deps[@]}"; do
		local DEP_SRCURL='' DEP_SHA256=''
		read -r DEP_SRCURL DEP_SHA256 < <(
			# This gets shellcheck to shut up about the non-constant source
			# shellcheck source=/dev/null
			source "${TERMUX_SCRIPTDIR}/packages/${dep}/build.sh"

			# ${var@a} outputs the declaration attributes of a varaible e.g. 'a' for arrays
			if [[ "${TERMUX_PKG_SRCURL@a}" == 'a' ]]; then
				echo "${TERMUX_PKG_SRCURL[0]}" "${TERMUX_PKG_SHA256[0]}"
			else
				echo "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_SHA256}"
			fi
		)

		rm -rf "${dep}"-* "${dep}"
		termux_download "${DEP_SRCURL}" "${TERMUX_PKG_CACHEDIR}/${dep}.tar.gz" "${DEP_SHA256}"
		tar -xf "${TERMUX_PKG_CACHEDIR}/${dep}.tar.gz"
		mv -v "${dep}"-* "${dep}"

		echo "INFO: Applying patches from $dep"
		local p
		for p in "${TERMUX_SCRIPTDIR}/packages/$dep/"*.patch; do
			patch -p1 -i "${p}" -d "${dep}"
		done
	done

	local f
	f=$(sed -nE "s|.*SPDX-FileCopyrightText.*: (.*)|\1|p" ChangeLog)
	sed \
		-e "s|<year> <copyright holders>|${f}|" \
		-i LICENSES/MIT.txt
}

termux_step_pre_configure() {
	termux_setup_zig
	unset CFLAGS LDFLAGS
}

termux_step_make() {
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" "static-${ZIG_TARGET_NAME}.tar.gz"
}

termux_step_make_install() {
	# allow ncdu2 to co-exist with ncdu
	tar -xf "static-${ZIG_TARGET_NAME}.tar.gz"
	mv -v ncdu ncdu2
	mv -v ncdu.1 ncdu2.1
	install -Dm755 -t "${TERMUX_PREFIX}/bin" ncdu2
	install -Dm644 -t "${TERMUX_PREFIX}/share/man/man1" ncdu2.1
}
