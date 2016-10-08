TERMUX_PKG_HOMEPAGE=http://ipfs.io
TERMUX_PKG_DESCRIPTION="wget for IPFS: retrieve files over IPFS and save them locally."
TERMUX_PKG_VERSION=0.0.1
TERMUX_PKG_SHA256=fd5b458e862e1b81a1dd03d1c764f838d12634c5e6ea4642dea76dbd82ae982f
TERMUX_PKG_SRCURL=https://dist.ipfs.io/ipget/v${TERMUX_PKG_VERSION}/ipget_v${TERMUX_PKG_VERSION}_linux-arm.tar.gz
TERMUX_PKG_FOLDERNAME=ipget
TERMUX_PKG_DEPENDS="ipfs"
TERMUX_PKG_BUILD_IN_SRC=no
TERMUX_PKG_PLATFORM_INDEPENDENT=no

termux_step_make_install () {
	mkdir -p ${TERMUX_PREFIX}/bin/
	cp ipget ${TERMUX_PREFIX}/bin/
}

