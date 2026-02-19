TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/kfilemetadata'
TERMUX_PKG_DESCRIPTION='A library for extracting file metadata'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kfilemetadata-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4e99cd8dc1fd784589c5b173f076bd5655eca2908fb61a31cb5404e1c7f64a88
TERMUX_PKG_DEPENDS="attr, ebook-tools, exiv2, ffmpeg, kf6-karchive (>= ${TERMUX_PKG_VERSION%.*}), kf6-kcodecs (>= ${TERMUX_PKG_VERSION%.*}), kf6-kconfig (>= ${TERMUX_PKG_VERSION%.*}), kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION%.*}), kf6-ki18n (>= ${TERMUX_PKG_VERSION%.*}), libc++, poppler-qt, qt6-qtbase, taglib"
TERMUX_PKG_BUILD_DEPENDS="catdoc, extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), kdegraphics-mobipocket, qt6-qttools"
TERMUX_PKG_RECOMMENDS="catdoc, kdegraphics-mobipocket"
TERMUX_PKG_AUTO_UPDATE=true
# libappimage can be added to TERMUX_PKG_BUILD_DEPENDS and TERMUX_PKG_RECOMMENDS when available
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DXATTR_INCLUDE_DIRS=$TERMUX_PREFIX/include
-DXATTR_LIBRARIES=$TERMUX_PREFIX/lib/libattr.so
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
