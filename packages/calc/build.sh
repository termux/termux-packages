TERMUX_PKG_HOMEPAGE=http://www.isthe.com/chongo/tech/comp/calc/
TERMUX_PKG_DESCRIPTION="Arbitrary precision console calculator"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.0.14
TERMUX_PKG_SRCURL=https://github.com/lcn2/calc/releases/download/v$TERMUX_PKG_VERSION/calc-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=f7727835a103d9712c571958e924e9c254bd148f08eb4348019bc34f8e71c55d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, readline"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make CC="$CC" \
		USE_READLINE="-DUSE_READLINE" \
		READLINE_EXTRAS="-lhistory -lncurses" \
		READLINE_LIB="-L$TERMUX_PREFIX/lib -lreadline" \
		READLINE_INCLUDE="-I$TERMUX_PREFIX/include" \
		DEFAULT_LIB_INSTALL_PATH="$TERMUX_PREFIX/lib" \
		LONG_BITS=$TERMUX_ARCH_BITS \
		T="$TERMUX_PREFIX" \
		BINDIR="$TERMUX_PREFIX/bin" \
		LIBDIR="$TERMUX_PREFIX/lib" \
		INCDIR="$TERMUX_PREFIX/include" \
		SCRIPTDIR="$TERMUX_PREFIX/share/calc/cscript" \
		CALC_SHAREDIR="$TERMUX_PREFIX/share/calc" \
		install 
}

termux_step_make_install() {
	:
}
