TERMUX_PKG_HOMEPAGE=https://github.com/AgentD/squashfs-tools-ng
TERMUX_PKG_DESCRIPTION="New set of tools for working with SquashFS images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="WMCB-Tech @marcusz"
TERMUX_PKG_VERSION="1.0.4"
TERMUX_PKG_SRCURL="https://github.com/AgentD/squashfs-tools-ng/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="addcd60f94971b7f7d7f65a973efa19714d273515a4f4bfc90138b0db0a4c9e9"
TERMUX_PKG_DEPENDS="zlib, liblz4, liblzo, zstd"

termux_step_pre_configure(){
	./autogen.sh
}
