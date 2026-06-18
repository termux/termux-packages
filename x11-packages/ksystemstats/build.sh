TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/ksystemstats"
TERMUX_PKG_DESCRIPTION="A plugin based system monitoring daemon"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.7.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/ksystemstats-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="2224ce41e42e75845aa886e192e7833ce638b86aa31ca0e4e3cb31ef36e4066b"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kio, kf6-solid, libc++, libksysguard, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libnl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
