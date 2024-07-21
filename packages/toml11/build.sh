TERMUX_PKG_HOMEPAGE=https://github.com/ToruNiina/toml11
TERMUX_PKG_DESCRIPTION="toml11 is a C++11 (or later) header-only toml parser/encoder depending only on C++ standard library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.1.0"
TERMUX_PKG_SRCURL=https://github.com/ToruNiina/toml11/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fb4c02cc708ae28e6fc3496514e3625e4b6738ed4ce40897710ca4d7a29de4f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_CXX_STANDARD=11
"
