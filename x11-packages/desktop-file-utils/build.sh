TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/desktop-file-utils
TERMUX_PKG_DESCRIPTION="Command line utilities for working with desktop entries"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a1de5da60cbdbe91e5c9c10ac9afee6c3deb019e0cee5fdb9a99dddc245f83d9
TERMUX_PKG_DEPENDS="glib"

termux_step_create_debscripts() {
	for i in postinst postrm triggers; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
