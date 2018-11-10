TERMUX_PKG_HOMEPAGE=http://zeromq.org/
TERMUX_PKG_DESCRIPTION="Fast messaging system built on sockets. C and C++ bindings. aka 0MQ, ZMQ."
TERMUX_PKG_VERSION=4.2.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=cc9090ba35713d59bb2f7d7965f877036c49c5558ea0c290b0dcc6f2a17e489f
TERMUX_PKG_SRCURL=https://github.com/zeromq/libzmq/releases/download/v${TERMUX_PKG_VERSION}/zeromq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libsodium"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libsodium --disable-libunwind --disable-Werror"

termux_step_post_extract_package() {
	./autogen.sh
}
