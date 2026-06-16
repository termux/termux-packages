TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kpipewire"
TERMUX_PKG_DESCRIPTION="Components relating to pipewire use in Plasma"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.7.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kpipewire-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=dbf839b779c508c2020bdf9d642762387cba85059291deab38e8a0c15223badb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, ffmpeg, kf6-kcoreaddons, kf6-ki18n, libdrm, libepoxy, pipewire, libva, mesa, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
