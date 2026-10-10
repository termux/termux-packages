TERMUX_PKG_HOMEPAGE=https://github.com/vasi/squashfuse
TERMUX_PKG_DESCRIPTION="FUSE filesystem to mount squashfs archives"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.3"
TERMUX_PKG_SRCURL=https://github.com/vasi/squashfuse/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4fda456c0f28f64db7e97f259069e747ffe29dcd13d4e2327350997b32eac914
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libfuse2, liblz4, liblzma, liblzo, zlib, zstd"

termux_step_pre_configure () {
	./autogen.sh
}
