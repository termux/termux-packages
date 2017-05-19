TERMUX_PKG_HOMEPAGE=http://ipfs.io
TERMUX_PKG_DESCRIPTION="fs-repo-migrations is a tool for migrating IPFS storage repositories to newer versions."
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SHA256=a312fbc41ca8a37413379002d3fbc4889922e62f9921aec7a2d08fa3be305e88
TERMUX_PKG_SRCURL=https://dist.ipfs.io/fs-repo-migrations/v${TERMUX_PKG_VERSION}/fs-repo-migrations_v${TERMUX_PKG_VERSION}_linux-arm.tar.gz
TERMUX_PKG_FOLDERNAME=fs-repo-migrations
TERMUX_PKG_DEPENDS="ipfs"
TERMUX_PKG_BUILD_IN_SRC=no
TERMUX_PKG_PLATFORM_INDEPENDENT=no

termux_step_make_install () {
	mkdir -p ${TERMUX_PREFIX}/bin/
	cp fs-repo-migrations ${TERMUX_PREFIX}/bin/
}

