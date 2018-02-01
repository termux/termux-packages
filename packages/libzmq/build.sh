TERMUX_PKG_HOMEPAGE=http://zeromq.org/
TERMUX_PKG_DESCRIPTION="Fast messaging system built on sockets. C and C++ bindings. aka 0MQ, ZMQ."
TERMUX_PKG_VERSION=4.2.3
TERMUX_PKG_SHA256=8f1e2b2aade4dbfde98d82366d61baef2f62e812530160d2e6d0a5bb24e40bc0
TERMUX_PKG_SRCURL=https://github.com/zeromq/libzmq/releases/download/v${TERMUX_PKG_VERSION}/zeromq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libsodium"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libsodium --disable-libunwind"

termux_step_post_extract_package() {
	./autogen.sh
}
