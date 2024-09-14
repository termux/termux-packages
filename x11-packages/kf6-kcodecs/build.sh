TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Method collection to manipulate strings using various encodings (KDE)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kcodecs-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d9dc2e3294aa32684990bde01bb88dedb2610a28d7c1d62a178a393fa566123b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
