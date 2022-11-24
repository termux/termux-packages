TERMUX_PKG_HOMEPAGE=https://github.com/vasi/squashfuse
TERMUX_PKG_DESCRIPTION="FUSE filesystem to mount squashfs archives"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.105
TERMUX_PKG_SHA256=3f776892ab2044ecca417be348e482fee2839db75e35d165b53737cb8153ab1e
TERMUX_PKG_SRCURL=https://github.com/vasi/squashfuse/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libfuse2, liblz4, liblzma, liblzo, zlib, zstd"

termux_step_pre_configure () {
	./autogen.sh
}
