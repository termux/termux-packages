TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdu
TERMUX_PKG_DESCRIPTION="Disk usage analyzer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSES/MIT.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4"
TERMUX_PKG_SRCURL=https://dev.yorhel.nl/download/ncdu-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4a3d0002309cf6a7cea791938dac9becdece4d529d0d6dc8d91b73b4e6855509
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# TODO drop all this once figure out how zig can work with bionic libc
	local NCURSES_SRCURL=$(. "${TERMUX_SCRIPTDIR}"/packages/ncurses/build.sh; echo ${TERMUX_PKG_SRCURL[0]})
	local NCURSES_SHA256=$(. "${TERMUX_SCRIPTDIR}"/packages/ncurses/build.sh; echo ${TERMUX_PKG_SHA256[0]})

	rm -fr ncurses-* ncurses
	termux_download "${NCURSES_SRCURL}" "${TERMUX_PKG_CACHEDIR}/ncurses.tar.gz" "${NCURSES_SHA256}"
	tar -xf "${TERMUX_PKG_CACHEDIR}/ncurses.tar.gz"
	mv -v ncurses-* ncurses

	echo "INFO: Applying patches from packages/ncurses"
	for p in "${TERMUX_SCRIPTDIR}"/packages/ncurses/*.patch; do
	patch -p1 -i "${p}" -d ncurses
	done

	local f=$(sed -nE "s|.*SPDX-FileCopyrightText.*: (.*)|\1|p" ChangeLog)
	sed \
		-e "s|<year> <copyright holders>|${f}|" \
		-i LICENSES/MIT.txt
	sed \
		-e "s|--with-default-terminfo-dir=/usr|--with-default-terminfo-dir=${TERMUX_PREFIX}|" \
		-i Makefile
}

termux_step_pre_configure() {
	termux_setup_zig
	unset CFLAGS LDFLAGS
}

termux_step_make() {
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" static-${ZIG_TARGET_NAME}.tar.gz
}

termux_step_make_install() {
	# allow ncdu2 to co-exist with ncdu
	tar -xf static-${ZIG_TARGET_NAME}.tar.gz
	mv -v ncdu ncdu2
	mv -v ncdu.1 ncdu2.1
	install -Dm755 -t "${TERMUX_PREFIX}/bin" ncdu2
	install -Dm644 -t "${TERMUX_PREFIX}/share/man/man1" ncdu2.1
}
