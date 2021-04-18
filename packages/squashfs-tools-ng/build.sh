TERMUX_PKG_HOMEPAGE=https://github.com/AgentD/squashfs-tools-ng
TERMUX_PKG_DESCRIPTION="New set of tools for working with SquashFS images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="WMCB-Tech @marcusz"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL="https://github.com/AgentD/squashfs-tools-ng/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="01f02a4dbc32a0016c57c7a214b9bed8659768fcb2213886b0dfc55d114cb653"
TERMUX_PKG_DEPENDS="zlib, liblz4, liblzo, zstd"

termux_step_pre_configure(){
	./autogen.sh
}
