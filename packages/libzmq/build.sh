TERMUX_PKG_HOMEPAGE=http://zeromq.org/
TERMUX_PKG_DESCRIPTION="Fast messaging system built on sockets. C and C++ bindings. aka 0MQ, ZMQ."
TERMUX_PKG_VERSION=4.2.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/zeromq/libzmq/releases/download/v${TERMUX_PKG_VERSION}/zeromq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5b23f4ca9ef545d5bd3af55d305765e3ee06b986263b31967435d285a3e6df6b
TERMUX_PKG_DEPENDS="libsodium"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libsodium"

termux_step_post_extract_package() {
	./autogen.sh
}
