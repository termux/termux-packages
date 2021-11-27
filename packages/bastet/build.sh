TERMUX_PKG_HOMEPAGE=http://fph.altervista.org/prog/bastet.html
TERMUX_PKG_DESCRIPTION="Tetris clone with 'bastard' block-choosing AI"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.43.2
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/fph/bastet/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_BUILD_DEPENDS="boost-static"
TERMUX_PKG_EXTRA_MAKE_ARGS=" BOOST_PO=$TERMUX_PREFIX/lib/libboost_program_options.a"
TERMUX_PKG_BUILD_IN_SRC=true
