TERMUX_PKG_HOMEPAGE=https://github.com/AgentD/squashfs-tools-ng
TERMUX_PKG_DESCRIPTION="New set of tools for working with SquashFS images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@WMCB-Tech"
TERMUX_PKG_VERSION="1.1.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/AgentD/squashfs-tools-ng/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="da4c00938a1fdec89808e05f43c6875180de1990e71837030071d2b639456f22"
TERMUX_PKG_DEPENDS="zlib, liblz4, liblzo, zstd"

termux_step_pre_configure(){
	autoreconf -fi
}
