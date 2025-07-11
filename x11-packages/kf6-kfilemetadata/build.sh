TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='A library for extracting file metadata'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.16.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kfilemetadata-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=47d680b62697421bdfea3dcbfeb563528e3eba8daf48564c3c3da564e37640c5
TERMUX_PKG_DEPENDS="attr, ebook-tools, exiv2, ffmpeg, kf6-karchive (>= ${_KF6_MINOR_VERSION}), kf6-kcodecs (>= ${_KF6_MINOR_VERSION}), kf6-kconfig (>= ${_KF6_MINOR_VERSION}), kf6-kcoreaddons (>= ${_KF6_MINOR_VERSION}), kf6-ki18n (>= ${_KF6_MINOR_VERSION}), libc++, poppler-qt, qt6-qtbase, taglib"
TERMUX_PKG_BUILD_DEPENDS="catdoc, extra-cmake-modules (>= ${_KF6_MINOR_VERSION}), kdegraphics-mobipocket, qt6-qttools"
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
