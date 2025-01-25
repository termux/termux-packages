TERMUX_PKG_HOMEPAGE=https://github.com/fcitx/fcitx5-chinese-addons
TERMUX_PKG_DESCRIPTION="Addons related to Chinese, including IME previous bundled inside fcitx4"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.8"
TERMUX_PKG_SRCURL="https://github.com/fcitx/fcitx5-chinese-addons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0182025f7451adb2df488812b31b900dfb59fb264a6b485fa2339e8ecd63bb41
TERMUX_PKG_DEPENDS="boost, fcitx5, fcitx5-qt, libc++, libcurl, libime, libopencc, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
# FIXME: Enable generating dictionary data
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_BROWSER=OFF
-DENABLE_DATA=OFF
-DENABLE_TEST=OFF
"
