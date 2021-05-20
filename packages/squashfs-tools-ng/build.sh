TERMUX_PKG_HOMEPAGE=https://github.com/AgentD/squashfs-tools-ng
TERMUX_PKG_DESCRIPTION="New set of tools for working with SquashFS images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="WMCB-Tech @marcusz"
TERMUX_PKG_VERSION="1.1.1"
TERMUX_PKG_SRCURL="https://github.com/AgentD/squashfs-tools-ng/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="e4d3dfc9f354267c65bf2dd7e483ad23a148d49b3946e2ab3918e1fbd69015c1"
TERMUX_PKG_DEPENDS="zlib, liblz4, liblzo, zstd"

termux_step_pre_configure(){
	autoreconf -fi
}
