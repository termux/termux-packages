TERMUX_PKG_HOMEPAGE=https://github.com/AgentD/squashfs-tools-ng
TERMUX_PKG_DESCRIPTION="New set of tools for working with SquashFS images"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@wmcbtech30"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL="https://github.com/AgentD/squashfs-tools-ng/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e6f627a97ae0f484905de1718728a8879e8600b324d22d09a63cf92e9c9e1132
TERMUX_PKG_DEPENDS="liblz4, liblzma, liblzo, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure(){
	autoreconf -fi
}
