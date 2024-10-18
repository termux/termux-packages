TERMUX_PKG_HOMEPAGE=https://github.com/ToruNiina/toml11
TERMUX_PKG_DESCRIPTION="toml11 is a C++11 (or later) header-only toml parser/encoder depending only on C++ standard library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.0"
TERMUX_PKG_SRCURL=https://github.com/ToruNiina/toml11/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9287971cd4a1a3992ef37e7b95a3972d1ae56410e7f8e3f300727ab1d6c79c2c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_CXX_STANDARD=11
"
