TERMUX_PKG_HOMEPAGE=https://fcitx-im.org/
TERMUX_PKG_DESCRIPTION="A generic input method framework"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.12"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/fcitx/fcitx5/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04fabc12cb8702f06aeb1399f30d41dd9c17a997ccac9a53352ba21a8aef16e7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="dbus, enchant, fcitx5-data, fmt, gdk-pixbuf, glib, iso-codes, json-c, libandroid-execinfo, libc++, libcairo, libevent, libexpat, libuuid, libuv, libxcb, libxkbcommon, libxkbfile, pango, xcb-imdkit, xcb-util, xcb-util-keysyms, xcb-util-wm, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDL_INCLUDE_DIR=$TERMUX_PREFIX/include
-DDL_LIBRARY=0
-DPTHREAD_INCLUDE_DIR=$TERMUX_PREFIX/include
-DENABLE_TEST=OFF
-DENABLE_WAYLAND=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -ldl"
}
