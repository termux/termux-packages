TERMUX_PKG_HOMEPAGE=https://github.com/vasi/squashfuse
TERMUX_PKG_DESCRIPTION="FUSE filesystem to mount squashfs archives"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.1"
TERMUX_PKG_SRCURL=https://github.com/vasi/squashfuse/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7730066d1e9baf0084c71674d168331296921e0d7ae0f34de7307744be4ed568
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libfuse2, liblz4, liblzma, liblzo, zlib, zstd"

termux_step_pre_configure () {
	./autogen.sh
}
