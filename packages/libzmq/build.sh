TERMUX_PKG_HOMEPAGE=http://zeromq.org/
TERMUX_PKG_DESCRIPTION="Fast messaging system built on sockets. C and C++ bindings. aka 0MQ, ZMQ."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=4.3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=bcbabe1e2c7d0eec4ed612e10b94b112dd5f06fcefa994a0c79a45d835cd21eb
TERMUX_PKG_SRCURL=https://github.com/zeromq/libzmq/releases/download/v${TERMUX_PKG_VERSION}/zeromq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libsodium"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libsodium --disable-libunwind --disable-Werror"

termux_step_post_extract_package() {
	./autogen.sh
}
