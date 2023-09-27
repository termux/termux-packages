TERMUX_PKG_HOMEPAGE=https://fcitx-im.org/
TERMUX_PKG_DESCRIPTION="A generic input method framework"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0.23
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/fcitx/fcitx5/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=50bc76a883942ec7bcfa93d1af3bc5961194f9a61d600253cf61588ae47bf02d
TERMUX_PKG_DEPENDS="dbus, enchant, fcitx5-data, gdk-pixbuf, iso-codes, json-c, libandroid-execinfo, libc++, libcairo, libevent, libexpat, libuuid, libxcb, libxkbcommon, libxkbfile, pango, xcb-imdkit, xcb-util, xcb-util-keysyms, xcb-util-wm, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, fmt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDL_INCLUDE_DIR=$TERMUX_PREFIX/include
-DPTHREAD_INCLUDE_DIR=$TERMUX_PREFIX/include
-DENABLE_TEST=OFF
-DENABLE_WAYLAND=OFF
"
