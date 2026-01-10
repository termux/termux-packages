TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/karchive"
TERMUX_PKG_DESCRIPTION="Qt addon providing access to numerous types of archives (KDE)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/karchive-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=84254bd0a51ff3d5e2fa22bb946309cec508f1fae726a7aea15149260c4db59d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libbz2, libc++, liblzma, qt6-qtbase, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
