TERMUX_PKG_HOMEPAGE=https://github.com/AgentD/squashfs-tools-ng
TERMUX_PKG_DESCRIPTION="New set of tools for working with SquashFS images"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_SRCURL="https://github.com/AgentD/squashfs-tools-ng/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=21f40dc82f69b721e92bfc539e47bfb8581753f8de492c877c59737ce2e3bf0f
TERMUX_PKG_DEPENDS="liblz4, liblzma, liblzo, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure(){
	autoreconf -fi
}
