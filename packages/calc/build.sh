TERMUX_PKG_HOMEPAGE=http://www.isthe.com/chongo/tech/comp/calc/
TERMUX_PKG_DESCRIPTION="Arbitrary precision console calculator"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.12.8.2
TERMUX_PKG_SRCURL=https://github.com/lcn2/calc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3bb24e13766a0b17fb69b2f30de6acca13f19e703c496d575d96703fe920b0b8
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, readline"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	# Fails with -j$TERMUX_MAKE_PROCESSES for some reason
	make USE_READLINE="-DUSE_READLINE" READLINE_EXTRAS="-lhistory -lncurses" \
		READLINE_LIB="-L$TERMUX_PREFIX/lib -lreadline" \
		READLINE_INCLUDE="-I$TERMUX_PREFIX/include" \
		DEFAULT_LIB_INSTALL_PATH="$TERMUX_PREFIX/lib" CC="$CC" -j1
}

termux_step_make_install() {
	make T="$TERMUX_PREFIX" BINDIR="/bin" LIBDIR="/lib" INCDIR="/include" \
		SCRIPTDIR="/share/calc/cscript" CALC_SHAREDIR="/share/calc" install 
}
