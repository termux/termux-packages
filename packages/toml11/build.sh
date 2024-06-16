TERMUX_PKG_HOMEPAGE=https://github.com/ToruNiina/toml11
TERMUX_PKG_DESCRIPTION="toml11 is a C++11 (or later) header-only toml parser/encoder depending only on C++ standard library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.0"
TERMUX_PKG_SRCURL=https://github.com/ToruNiina/toml11/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f3dc3095f22e38745a5d448ac629f69b7ee76d2b3e6d653e4ce021deb7f7266e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_CXX_STANDARD=11
"
