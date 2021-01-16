TERMUX_PKG_HOMEPAGE=https://bitcoincore.org/
TERMUX_PKG_DESCRIPTION="Bitcoin Core"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.21.0
TERMUX_PKG_SRCURL=https://github.com/bitcoin/bitcoin/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1a91202c62ee49fb64d57a52b8d6d01cd392fffcbef257b573800f9289655f37
TERMUX_PKG_CONFFILES="var/service/bitcoind/run var/service/bitcoind/log/run"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--with-daemon
--with-gui=no
--without-libs
--prefix=${TERMUX_PKG_SRCDIR}/depends/$TERMUX_HOST_PLATFORM
--bindir=$TERMUX_PREFIX/bin
"

termux_step_pre_configure() {
	export ANDROID_TOOLCHAIN_BIN="$TERMUX_STANDALONE_TOOLCHAIN/bin"
	(cd depends && make HOST=$TERMUX_HOST_PLATFORM NO_QT=1 -j $TERMUX_MAKE_PROCESSES)
	./autogen.sh
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/var/service
	cd $TERMUX_PREFIX/var/service
	mkdir -p bitcoind/log
	echo "#!$TERMUX_PREFIX/bin/sh" > bitcoind/run
	echo 'exec bitcoind 2>&1' >> bitcoind/run
	chmod +x bitcoind/run
	touch bitcoind/down
	ln -sf $TERMUX_PREFIX/share/termux-services/svlogger bitcoind/log/run
}
