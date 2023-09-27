TERMUX_PKG_HOMEPAGE=https://www.jedsoft.org/slang/
TERMUX_PKG_DESCRIPTION="S-Lang is a powerful interpreted language"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_SRCURL=https://www.jedsoft.org/releases/slang/slang-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=f9145054ae131973c61208ea82486d5dd10e3c5cdad23b7c4a0617743c8f5a18
TERMUX_PKG_DEPENDS="libiconv, libpng, pcre, oniguruma, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/slsh.rc"

# Supports only make -j1
TERMUX_MAKE_PROCESSES=1
