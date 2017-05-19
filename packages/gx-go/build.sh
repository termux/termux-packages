TERMUX_PKG_HOMEPAGE=http://ipfs.io
TERMUX_PKG_DESCRIPTION="gx-go is a gx helper for golang"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SHA256=d6bca968ab9ee1713f523e2e8626e9a62471992d238ddb2aead57a20257ce67d
TERMUX_PKG_SRCURL=https://dist.ipfs.io/gx-go/v${TERMUX_PKG_VERSION}/gx-go_v${TERMUX_PKG_VERSION}_linux-arm.tar.gz
TERMUX_PKG_FOLDERNAME=gx-go
TERMUX_PKG_DEPENDS="ipfs, gx, golang"
TERMUX_PKG_BUILD_IN_SRC=no
TERMUX_PKG_PLATFORM_INDEPENDENT=no

termux_step_make_install () {
	mkdir -p ${TERMUX_PREFIX}/bin/
	cp gx-go ${TERMUX_PREFIX}/bin/
}

