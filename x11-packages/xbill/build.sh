TERMUX_PKG_HOMEPAGE=http://www.xbill.org/
TERMUX_PKG_DESCRIPTION="The classic game of Bill vs. PCs"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="README"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION=2.1
TERMUX_PKG_SRCURL=http://www.xbill.org/download/xbill-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0efdfff1ce2df70b7a15601cb488cd7b2eb918d21d78e877bd773f112945608d
TERMUX_PKG_DEPENDS="libx11, libxaw, libxmu, libxpm, libxt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-athena --disable-motif --disable-gtk"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	install -Dm644 -t "${TERMUX_PREFIX}/share/applications" "${TERMUX_PKG_BUILDER_DIR}/xbill.desktop"
	install -Dm644 -t "${TERMUX_PREFIX}/share/pixmaps" "${TERMUX_PKG_BUILDER_DIR}/xbill.xpm"
}
