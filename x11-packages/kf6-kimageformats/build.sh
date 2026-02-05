TERMUX_PKG_HOMEPAGE=https://invent.kde.org/frameworks/kimageformats
TERMUX_PKG_DESCRIPTION="Image format plugins for KDE"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kimageformats-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d6eede9a75aa4b33c3e8afdebdcc9664cf423effeabe684b21dc1cc9728a2073
TERMUX_PKG_DEPENDS="imath, kf6-karchive (>= ${TERMUX_PKG_VERSION%.*}), libc++, libheif, libjxl, libraw, openjpeg, openexr"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DKIMAGEFORMATS_HEIF=ON
"
