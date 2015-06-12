TERMUX_PKG_HOMEPAGE=https://code.google.com/p/googletest/
TERMUX_PKG_DESCRIPTION="Google C++ testing framework"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_SRCURL=https://googletest.googlecode.com/files/gtest-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
        cp ./lib/.libs/*.so* $TERMUX_PREFIX/lib
        rm -Rf $TERMUX_PREFIX/include/gtest
        cp -R $TERMUX_PKG_SRCDIR/include/gtest/ $TERMUX_PREFIX/include/gtest/
}
