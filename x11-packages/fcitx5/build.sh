TERMUX_PKG_HOMEPAGE=https://fcitx-im.org/
TERMUX_PKG_DESCRIPTION="A generic input method framework"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.17"
TERMUX_PKG_SRCURL=https://github.com/fcitx/fcitx5/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=84a927fa5f3a3c713c9388a126a2e9b516f6ca7e6402b140cd82ff6614e61eaa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="dbus, enchant, fcitx5-data, fmt, gdk-pixbuf, glib, iso-codes, libandroid-execinfo, libc++, libcairo, libevent, libexpat, libuuid, libuv, libxcb, libxkbcommon, libxkbfile, pango, xcb-imdkit, xcb-util, xcb-util-keysyms, xcb-util-wm, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, nlohmann-json"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDL_INCLUDE_DIR=$TERMUX_PREFIX/include
-DDL_LIBRARY=0
-DPTHREAD_INCLUDE_DIR=$TERMUX_PREFIX/include
-DENABLE_TEST=OFF
-DENABLE_WAYLAND=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -ldl"
	CXXFLAGS+=" -fexperimental-library"
}
