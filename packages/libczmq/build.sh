TERMUX_PKG_HOMEPAGE=https://zeromq.org/
TERMUX_PKG_DESCRIPTION="High-level C binding for ZeroMQ"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/zeromq/czmq/releases/download/v${TERMUX_PKG_VERSION}/czmq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d720a204c2a58645d6f7643af15d563a712dad98c9d32c1ed913377daa6ac39
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="liblz4, libuuid, libzmq"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-drafts=no"

termux_step_pre_configure() {
	CFLAGS+=" -DCZMQ_HAVE_ANDROID=1"
	LDFLAGS+=" -llog"
	autoconf
}
