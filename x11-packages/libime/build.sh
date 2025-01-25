TERMUX_PKG_HOMEPAGE=https://github.com/fcitx/libime
TERMUX_PKG_DESCRIPTION="A library to support generic input method implementation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.10"
TERMUX_PKG_SRCURL=git+https://github.com/fcitx/libime
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="boost, fcitx5, libc++, zstd"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
# FIXME: Enable generating dictionary data
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_DATA=OFF
-DENABLE_TEST=OFF
"
