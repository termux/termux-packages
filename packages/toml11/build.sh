TERMUX_PKG_HOMEPAGE=https://github.com/ToruNiina/toml11
TERMUX_PKG_DESCRIPTION="toml11 is a C++11 (or later) header-only toml parser/encoder depending only on C++ standard library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.2"
TERMUX_PKG_SRCURL=https://github.com/ToruNiina/toml11/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d1bec1970d562d328065f2667b23f9745a271bf3900ca78e92b71a324b126070
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_CXX_STANDARD=11
"
