TERMUX_PKG_HOMEPAGE=http://zeromq.org/
TERMUX_PKG_DESCRIPTION="Fast messaging system built on sockets. C and C++ bindings. aka 0MQ, ZMQ."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=4.3.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=ebd7b5c830d6428956b67a0454a7f8cbed1de74b3b01e5c33c5378e22740f763
TERMUX_PKG_SRCURL=https://github.com/zeromq/libzmq/releases/download/v${TERMUX_PKG_VERSION}/zeromq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libc++, libsodium"
TERMUX_PKG_BREAKS="libzmq-dev"
TERMUX_PKG_REPLACES="libzmq-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libsodium --disable-libunwind --disable-Werror"

termux_step_post_extract_package() {
	./autogen.sh
}
