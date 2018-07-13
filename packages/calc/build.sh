TERMUX_PKG_VERSION=2.12.6.7
TERMUX_PKG_DESCRIPTION="Arbitrary precision console calculator"
TERMUX_PKG_HOMEPAGE="http://www.isthe.com/chongo/tech/comp/calc/"
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_SRCURL="http://www.isthe.com/chongo/src/calc/calc-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256='3a4f1acde15941048214f393beb97f9e12fc1ef2585fe0ab026e93ebcd19dd46'
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CLANG=no
TERMUX_PKG_EXTRA_MAKE_ARGS="T=$TERMUX_PREFIX/.."

termux_step_make() {
  # Configure the project to be able to generate included help files
  make -j1 hsrc

  # Generate the included help
  make -j1 help/builtin

  cp $TERMUX_PKG_BUILDER_DIR/configured-for-android/* .

  # Stop make from configuring again. Not doing this causes the build to
  # break nondeterministically as it sometimes decides to reconfigure itself in this step.
  sed -i 's/\(.*h\): /\1.do-not-make: /' Makefile

  make -j1 all \
    T="$TERMUX_PREFIX/.." \
    USE_READLINE="-DUSE_READLINE" \
    READLINE_LIB="-L$TERMUX_PREFIX/lib -lreadline" \
    READLINE_EXTRAS="-lhistory -lncurses" \
    target=Linux \
    CC=$CC \
    LCC=$CC \
    EXTRA_CFLAGS="$CFLAGS -I$TERMUX_PREFIX/include" \
    EXTRA_LDFLAGS="-L$TERMUX_PREFIX/lib $LDFLAGS"
}
