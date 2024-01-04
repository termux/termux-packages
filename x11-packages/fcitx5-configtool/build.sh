TERMUX_PKG_HOMEPAGE=https://fcitx-im.org/
TERMUX_PKG_DESCRIPTION="Configuration tool for Fcitx5"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.3"
TERMUX_PKG_SRCURL=https://github.com/fcitx/fcitx5-configtool/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=88e91cfb9d54e1a20efc9412be6f7b9f6708b4ac6013069aaa1db90209e241d8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="fcitx5, fcitx5-qt, iso-codes, kitemviews, kwidgetsaddons, libc++, libx11, libxkbfile, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras, xkeyboard-config"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_TEST=OFF
-DENABLE_CONFIG_QT=ON
-DENABLE_KCM=OFF
"
