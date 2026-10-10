TERMUX_PKG_HOMEPAGE=https://invent.kde.org/frameworks/kimageformats
TERMUX_PKG_DESCRIPTION="Image format plugins for KDE"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.31.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kimageformats-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=62a0a92b6b7e117256c0ad115f1c7cc8ef343bb3b80b721cc9240cfa76657c8c
TERMUX_PKG_DEPENDS="imath, kf6-karchive (>= ${TERMUX_PKG_VERSION%.*}), libavif, libc++, libheif, libjxl, libraw, openjpeg, openexr"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DKIMAGEFORMATS_HEIF=ON
"
