TERMUX_PKG_HOMEPAGE=https://marzer.github.io/tomlplusplus/
TERMUX_PKG_DESCRIPTION="Header-only TOML config file parser and serializer for C++ 17"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="3.5.0"
TERMUX_PKG_SRCURL="https://github.com/marzer/tomlplusplus/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0fab22df275d188b7c8c698d06b9dcabdaa3f083f9b8da106cbfd2fe181bac62
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
