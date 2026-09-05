TERMUX_PKG_HOMEPAGE=https://www.freepascal.org
TERMUX_PKG_DESCRIPTION="The Free Pascal Compiler (Turbo Pascal 7.0 and Delphi compatible)"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="fpcsrc/rtl/COPYING.FPC, fpcsrc/rtl/COPYING.txt"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.dev>"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/project/freepascal/Source/$TERMUX_PKG_VERSION/fpcbuild-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=85ef993043bb83f999e2212f1bca766eb71f6f973d362e2290475dbaaf50161f
TERMUX_PKG_DEPENDS="libc++, libexpat, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="OS_TARGET=android NOGDB=1"
# TERMUX_PKG_NO_ELF_CLEANER=true

__setup_wrapper_bin() {
	local WRAPPER_BIN="${TERMUX_PKG_TMPDIR}/wrapper"

	mkdir -p "${WRAPPER_BIN}"

	cat <<-EOF >"$WRAPPER_BIN/$TERMUX_HOST_PLATFORM-ld"
		#!/bin/sh
			exec $(command -v "$LD") "\$@"
	EOF

	cat <<-EOF >"$WRAPPER_BIN/$TERMUX_HOST_PLATFORM-ar"
		#!/bin/sh
			exec $(command -v "$AR") "\$@"
	EOF

	cat <<-EOF >"$WRAPPER_BIN/$TERMUX_HOST_PLATFORM-as"
		#!/bin/sh
			exec $(command -v "$AS") -c -x assembler "\$@"
	EOF

	chmod +x "$WRAPPER_BIN/$TERMUX_HOST_PLATFORM"-{ld,as,ar}

	export PATH="${WRAPPER_BIN}:${PATH}"
}

termux_step_pre_configure() {
	termux_setup_fpc

	local _ARCH="${TERMUX_ARCH}"
	[[ "${TERMUX_ARCH}" == "i686" ]] && _ARCH=i386

	TERMUX_PKG_EXTRA_MAKE_ARGS+=" CPU_TARGET=${_ARCH}"

	__setup_wrapper_bin

	# fpc searches PATH for ld for host-build.
	# Since we have ld of clang before hosts, therefore it fails.
	export PATH="/usr/bin:${PATH}"

	fpcmake -T "${_ARCH}"-android
}

termux_step_make() {
	cd fpcsrc/ || exit

	make crossall $TERMUX_PKG_EXTRA_MAKE_ARGS
	make install

	# ls "$TERMUX_PREFIX"/man

	# exit 0
}

termux_step_make_install() {
	:
}

# termux_step_post_make_install() {
# 	# make crossinstall
# 	ls "$TERMUX_PREFIX"/man
# }
