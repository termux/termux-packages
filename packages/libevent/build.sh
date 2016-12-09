TERMUX_PKG_HOMEPAGE=http://libevent.org/
TERMUX_PKG_DESCRIPTION="Library that provides asynchronous event notification"
TERMUX_PKG_VERSION=2.0.22
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/libevent/libevent/releases/download/release-${TERMUX_PKG_VERSION}-stable/libevent-${TERMUX_PKG_VERSION}-stable.tar.gz
# Strip away libevent core, extra and openssl libraries until someone uses them
TERMUX_PKG_RM_AFTER_INSTALL="bin/event_rpcgen.py lib/libevent_*"
