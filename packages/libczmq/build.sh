TERMUX_PKG_HOMEPAGE=https://zeromq.org/
TERMUX_PKG_DESCRIPTION="High-level C binding for ZeroMQ"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.0
TERMUX_PKG_SRCURL=https://github.com/zeromq/czmq/releases/download/v${TERMUX_PKG_VERSION}/czmq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cfab29c2b3cc8a845749758a51e1dd5f5160c1ef57e2a41ea96e4c2dcc8feceb
TERMUX_PKG_DEPENDS="libzmq, libsodium, liblz4, libuuid"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-drafts=no"

termux_step_pre_configure() {
	CFLAGS+=" -DCZMQ_HAVE_ANDROID=1"
	LDFLAGS+=" -llog"
	autoconf
}