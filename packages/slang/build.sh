TERMUX_PKG_HOMEPAGE=https://www.jedsoft.org/slang/
TERMUX_PKG_DESCRIPTION="S-Lang is a powerful interpreted language"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SRCURL=https://www.jedsoft.org/releases/slang/slang-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=fc9e3b0fc4f67c3c1f6d43c90c16a5c42d117b8e28457c5b46831b8b5d3ae31a
TERMUX_PKG_DEPENDS="libiconv, libpng, pcre, oniguruma, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/slsh.rc"

# Supports only make -j1
TERMUX_MAKE_PROCESSES=1
