TERMUX_PKG_HOMEPAGE=https://github.com/fcitx/fcitx5-chinese-addons
TERMUX_PKG_DESCRIPTION="Addons related to Chinese, including IME previous bundled inside fcitx4"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.7"
TERMUX_PKG_SRCURL="https://github.com/fcitx/fcitx5-chinese-addons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0280847682dad4ed0efa918f573aee35c3f5c03f0634dc79c2fb757ff5019666
TERMUX_PKG_DEPENDS="boost, fcitx5, fcitx5-qt, libc++, libcurl, libime, libopencc, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
# FIXME: Enable generating dictionary data
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_BROWSER=OFF
-DENABLE_DATA=OFF
-DENABLE_TEST=OFF
"
