TERMUX_PKG_HOMEPAGE=https://bitcoincore.org/
TERMUX_PKG_DESCRIPTION="Bitcoin Core"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="28.1"
TERMUX_PKG_SRCURL=https://github.com/bitcoin/bitcoin/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=26f82493554d176c1dd65ca82383891701c81e00e7f824c2dfb9a3d3e6701082
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libevent"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_SERVICE_SCRIPT=("bitcoind" 'exec bitcoind 2>&1')
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--disable-fuzz-binary
--with-daemon
--with-gui=no
--without-libs
--prefix=${TERMUX_PKG_SRCDIR}/depends/$TERMUX_HOST_PLATFORM
--bindir=$TERMUX_PREFIX/bin
--mandir=$TERMUX_PREFIX/share/man
"

termux_step_pre_configure() {
	./autogen.sh
}
