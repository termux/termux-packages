TERMUX_PKG_HOMEPAGE=https://zeromq.org/
TERMUX_PKG_DESCRIPTION="Fast messaging system built on sockets. C and C++ bindings. aka 0MQ, ZMQ."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3.3
TERMUX_PKG_SRCURL=https://github.com/zeromq/libzmq/releases/download/v${TERMUX_PKG_VERSION}/zeromq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d9285db37ae942ed0780c016da87060497877af45094ff9e1a1ca736e3875a2
TERMUX_PKG_DEPENDS="libc++, libsodium"
TERMUX_PKG_BREAKS="libzmq-dev"
TERMUX_PKG_REPLACES="libzmq-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libsodium --disable-libunwind --disable-Werror"

termux_step_post_get_source() {
	./autogen.sh
}
