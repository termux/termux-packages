TERMUX_PKG_HOMEPAGE=https://github.com/AgentD/squashfs-tools-ng
TERMUX_PKG_DESCRIPTION="New set of tools for working with SquashFS images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@wmcbtech30"
TERMUX_PKG_VERSION="1.1.3"
TERMUX_PKG_SRCURL="https://github.com/AgentD/squashfs-tools-ng/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="4214083eb921b89d194e41697c31dc086c059518e51fe0ee4eee88318c19ad0d"
TERMUX_PKG_DEPENDS="zlib, liblz4, liblzo, zstd"

termux_step_pre_configure(){
	autoreconf -fi
}
