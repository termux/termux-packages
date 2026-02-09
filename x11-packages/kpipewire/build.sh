TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kpipewire"
TERMUX_PKG_DESCRIPTION="Components relating to pipewire use in Plasma"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kpipewire-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4aacdb440cb09df418228aafce12d2565a894b3a8b98f34f05aa5a6f1ebce354
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, ffmpeg, kf6-kcoreaddons, kf6-ki18n, libdrm, libepoxy, pipewire, libva, mesa, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
