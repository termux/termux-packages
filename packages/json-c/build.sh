TERMUX_PKG_HOMEPAGE=https://github.com/json-c/json-c/wiki
TERMUX_PKG_DESCRIPTION="A JSON implementation in C"
TERMUX_PKG_MAINTAINER="Balazs Kutil @balazs_kutil"
TERMUX_PKG_VERSION=0.13
TERMUX_PKG_SHA256=0316780be9ad16c42d7c26b015a784fd5df4b0909fef0aba51cfb13e492ac24d
TERMUX_PKG_SRCURL=https://s3.amazonaws.com/json-c_releases/releases/json-c-${TERMUX_PKG_VERSION}.tar.gz

termux_step_make () {
	make \
		LDFLAGS="$LDFLAGS -llog"
}
