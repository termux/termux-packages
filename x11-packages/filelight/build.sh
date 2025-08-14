TERMUX_PKG_HOMEPAGE="https://apps.kde.org/filelight/"
TERMUX_PKG_DESCRIPTION="View disk usage information"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.08.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/filelight-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6080649ed7621178a7aeff1d3070629caa3d91da4978bcc5b568c75bedf53185
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kirigami-addons, kf6-kwidgetsaddons, kf6-qqc2-desktop-style, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
