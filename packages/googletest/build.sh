TERMUX_PKG_HOMEPAGE=https://code.google.com/p/googletest/
TERMUX_PKG_DESCRIPTION="Google C++ testing framework"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_SRCURL=https://github.com/google/googletest/archive/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=googletest-release-$TERMUX_PKG_VERSION
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

