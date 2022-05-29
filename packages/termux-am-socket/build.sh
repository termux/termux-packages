TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-am-socket
TERMUX_PKG_DESCRIPTION="A faster version of am with less features that only works while Termux is running"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_SRCURL=https://github.com/termux/termux-am-socket/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3515006eb23d0c66c5c8798338055e8d04d9235248a4b9d89122956c582756b4

termux_step_post_get_source() {

	for file in "${TERMUX_PKG_SRCDIR}/"*; do
		sed -i'' -E -e "s|^(TERMUX_AM_SOCKET_VERSION=).*|\1$TERMUX_PKG_FULLVERSION|" \
			-e "s|\@TERMUX_APP_PACKAGE\@|${TERMUX_APP_PACKAGE}|g" \
			-e "s|\@TERMUX_APPS_DIR\@|${TERMUX_APPS_DIR}|g" \
			"$file"
	done

}
