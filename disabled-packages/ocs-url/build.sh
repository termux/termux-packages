TERMUX_PKG_HOMEPAGE=https://www.opendesktop.org/p/1136805/
TERMUX_PKG_DESCRIPTION="An install helper program for items served via OpenCollaborationServices (ocs://)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://www.opencode.net/dfn2/ocs-url
TERMUX_PKG_GIT_BRANCH=release-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtdeclarative, qt5-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PREFIX=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	./scripts/prepare
}

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_SRCDIR/README.md
}
