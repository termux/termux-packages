TERMUX_PKG_HOMEPAGE=https://github.com/json-c/json-c/wiki
TERMUX_PKG_DESCRIPTION="A JSON implementation in C"
TERMUX_PKG_VERSION=0.12.1
TERMUX_PKG_MAINTAINER="Balazs Kutil @balazs_kutil"
TERMUX_PKG_SRCURL=https://s3.amazonaws.com/json-c_releases/releases/json-c-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2a136451a7932d80b7d197b10441e26e39428d67b1443ec43bbba824705e1123
TERMUX_PKG_FOLDERNAME=json-c-${TERMUX_PKG_VERSION}

termux_step_make () {
	make \
		LDFLAGS="$LDFLAGS -llog"
}
