TERMUX_PKG_HOMEPAGE=http://zeromq.org/
TERMUX_PKG_DESCRIPTION="Fast messaging system built on sockets. C and C++ bindings. aka 0MQ, ZMQ."
TERMUX_PKG_VERSION=4.2.1
TERMUX_PKG_SRCURL=https://github.com/zeromq/libzmq/releases/download/v${TERMUX_PKG_VERSION}/zeromq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=27d1e82a099228ee85a7ddb2260f40830212402c605a4a10b5e5498a7e0e9d03
TERMUX_PKG_DEPENDS="libsodium"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libsodium"
