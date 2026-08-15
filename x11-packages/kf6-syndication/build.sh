TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/syndication'
TERMUX_PKG_DESCRIPTION='RSS/Atom parser library'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.29.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/syndication-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f5a00d13eaf0401e9e4f3ffccda4876e2bcf84fb8dc2613a5d087971b377df1f
TERMUX_PKG_DEPENDS="kf6-kcodecs (>= ${TERMUX_PKG_VERSION%.*}), qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
