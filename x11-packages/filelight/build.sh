TERMUX_PKG_HOMEPAGE="https://apps.kde.org/filelight/"
TERMUX_PKG_DESCRIPTION="View disk usage information"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.12.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/filelight-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f8102f0d74f7dc3b6f17906993cbc63570f498c6f016a39a13503fdbe6d3b6b0
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kirigami-addons, kf6-kwidgetsaddons, kf6-qqc2-desktop-style, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
