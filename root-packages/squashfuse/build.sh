TERMUX_PKG_HOMEPAGE=https://github.com/vasi/squashfuse
TERMUX_PKG_DESCRIPTION="FUSE filesystem to mount squashfs archives"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.2"
TERMUX_PKG_SRCURL=https://github.com/vasi/squashfuse/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=db0238c5981dabbd80ee09ae15387f390091668ca060a7bc38047912491443d3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libfuse2, liblz4, liblzma, liblzo, zlib, zstd"

termux_step_pre_configure () {
	./autogen.sh
}
