TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kdav"
TERMUX_PKG_DESCRIPTION="A DAV protocol implemention with KJobs"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.27.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kdav-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="e0af4190960d65f5c8475f01213ea4e68a07763ffeaa6766de4b7f50529e0498"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-ki18n, kf6-kio, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
