TERMUX_PKG_HOMEPAGE=https://codeberg.org/newsraft/newsraft
TERMUX_PKG_DESCRIPTION="Newsraft is a feed reader with text-based user interface"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.35"
TERMUX_PKG_SRCURL=https://codeberg.org/newsraft/newsraft/archive/newsraft-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a87c8a9b8556650d18443baf827cf930aa4a5c5361a36397b95f275e28d540d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="curl, gumbo-parser, libexpat, libsqlite"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	make install EXAMPLES_DIR="$TERMUX_PREFIX/share/doc/${TERMUX_PKG_NAME}/example"
	make install-desktop
	install -Dm644 doc/changes.md "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/changes.md"
}

termux_step_install_license() {
	for FILE in "${TERMUX_PKG_SRCDIR}"/doc/license*; do
		cp -f "$FILE" "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/"
	done
}
