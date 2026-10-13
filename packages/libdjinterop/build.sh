TERMUX_PKG_HOMEPAGE=https://github.com/xsco/libdjinterop
TERMUX_PKG_DESCRIPTION="C++ library for access to DJ record libraries"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.27.1"
TERMUX_PKG_SRCURL="https://github.com/xsco/libdjinterop/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=4c7393ab70b7c92374557e72c86f650bea73ba50e59f6e5a683c69038cc7ea48
# ABI of libdjinterop is not yet stable, so any update requires rebuilding reverse dependencies
# See: https://github.com/mixxxdj/mixxx/blob/428dc665436492f1554d958ad014acca3eb4c8b1/CMakeLists.txt#L3179
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++, libsqlite, zlib"
