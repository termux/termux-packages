TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Utility libraries for XC Binding - Standard X key constants and conversion to/from keycodes"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_REVISION=24
TERMUX_PKG_SRCURL=https://xcb.freedesktop.org/dist/xcb-util-keysyms-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0ef8490ff1dede52b7de533158547f8b454b241aa3e4dcca369507f66f216dd9
TERMUX_PKG_DEPENDS="libxcb"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/xcb-util-keysyms $TERMUX_PKG_BUILDER_DIR/LICENSE
}
