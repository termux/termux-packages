TERMUX_PKG_HOMEPAGE=https://fcitx-im.org/
TERMUX_PKG_DESCRIPTION="Configuration tool for Fcitx5"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.11"
TERMUX_PKG_SRCURL=https://github.com/fcitx/fcitx5-configtool/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e4d84224b38df2a227225f5a3fb4667632925de65a647a0474ecc3d195e6ea86
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="fcitx5, fcitx5-qt, iso-codes, kf6-kdbusaddons, kf6-kitemviews, kf6-kwidgetsaddons, kf6-kwindowsystem, libc++, libx11, libxkbfile, qt6-qtbase, qt6-qtsvg, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_TEST=OFF
-DENABLE_CONFIG_QT=ON
-DENABLE_KCM=OFF
-DUSE_QT6=ON
"
