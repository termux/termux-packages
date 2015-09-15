# See https://ghc.haskell.org/trac/ghc/wiki/Building/CrossCompiling
#     https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux
TERMUX_PKG_HOMEPAGE=https://www.haskell.org/ghc/
TERMUX_PKG_DESCRIPTION="The Glasgow Haskell Compilation system"
TERMUX_PKG_VERSION=7.10.2
TERMUX_PKG_SRCURL=http://downloads.haskell.org/~ghc/${TERMUX_PKG_VERSION}/ghc-${TERMUX_PKG_VERSION}-src.tar.xz
TERMUX_PKG_FOLDERNAME=ghc-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes
# TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-target=$TERMUX_HOST_PLATFORM --host=x86_64-unknown-linux --build=x86_64-unknown-linux --target=$TERMUX_HOST_PLATFORM"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-iconv-includes=$TERMUX_PREFIX/include -with-iconv-libraries=$TERMUX_PREFIX/lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-curses-includes=$TERMUX_PREFIX/include/ncursesw -with-curses-libraries=$TERMUX_PREFIX/lib"

ORIG_CFLAGS="$CFLAGS"
ORIG_CPPFLAGS="$CPPFLAGS"
ORIG_LDFLAGS="$LDFLAGS"

unset AR
unset AS
unset CC
export CFLAGS=""
unset CPP
export CPPFLAGS=""
unset CXXFLAGS
unset CXX
export LDFLAGS=""
unset LD
unset PKG_CONFIG
unset RANLIB

termux_step_pre_configure () {
	echo "GhcStage2HcOpts = $ORIG_CFLAGS $ORIG_CPPFLAGS $ORIG_LDFLAGS" > mk/build.mk
	echo "INTEGER_LIBRARY = integer-simple" >> mk/build.mk
}
