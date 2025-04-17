TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/desktop-file-utils
TERMUX_PKG_DESCRIPTION="Command line utilities for working with desktop entries"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.28"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4401d4e231d842c2de8242395a74a395ca468cd96f5f610d822df33594898a70
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"

termux_step_create_debscripts() {
	for i in $(test "$TERMUX_PACKAGE_FORMAT" != "pacman" && echo postinst) postrm triggers; do
		sed \
			-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			-e "s|@TERMUX_PACKAGE_FORMAT@|${TERMUX_PACKAGE_FORMAT}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
