TERMUX_PKG_HOMEPAGE=http://ipfs.io
TERMUX_PKG_DESCRIPTION="ipfs-update is a CLI tool to help update and install IPFS easily."
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SHA256=77b6d4b50bb7f6ae8df1f4223fbd94a8ae8bfbbc41e767a9c38c018b06597a75
TERMUX_PKG_SRCURL=https://dist.ipfs.io/ipfs-update/v${TERMUX_PKG_VERSION}/ipfs-update_v${TERMUX_PKG_VERSION}_linux-arm.tar.gz
TERMUX_PKG_DEPENDS="ipfs"
TERMUX_PKG_FOLDERNAME=ipfs-update
TERMUX_PKG_BUILD_IN_SRC=no
TERMUX_PKG_PLATFORM_INDEPENDENT=no

termux_step_make_install () {
	cp ipfs-update ${TERMUX_PREFIX}
}

