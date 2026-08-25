TERMUX_PKG_HOMEPAGE=https://marzer.github.io/tomlplusplus/
TERMUX_PKG_DESCRIPTION="Header-only TOML config file parser and serializer for C++ 17"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.0"
TERMUX_PKG_SRCURL="https://github.com/marzer/tomlplusplus/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8517f65938a4faae9ccf8ebb36631a38c1cadfb5efa85d9a72e15b9e97d25155
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
