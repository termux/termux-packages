TERMUX_PKG_HOMEPAGE=https://bitcoincore.org/
TERMUX_PKG_DESCRIPTION="Bitcoin Core"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.18.1
TERMUX_PKG_SRCURL=https://github.com/bitcoin/bitcoin/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=db3c76ac913adfd67e3c7ff243b443c9706f81dd382d1212875fefc2de1ea5ff
TERMUX_PKG_DEPENDS="boost, libdb, libevent, libzmq, termux-services"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-daemon
--with-boost-chrono=boost_chrono
--with-boost-filesystem=boost_filesystem
--with-boost-system=boost_system
--with-boost-thread=boost_thread
--with-incompatible-bdb
--without-libs
"

termux_step_pre_configure() {
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
