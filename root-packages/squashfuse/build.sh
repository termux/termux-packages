TERMUX_PKG_HOMEPAGE=https://github.com/vasi/squashfuse
TERMUX_PKG_DESCRIPTION="FUSE filesystem to mount squashfs archives"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.104
TERMUX_PKG_REVISION=0
TERMUX_PKG_SHA256=9e6f4fb65bb3e5de60c8714bb7f5cbb08b5534f7915d6a4aeea008e1c669bd35
TERMUX_PKG_SRCURL=https://github.com/vasi/squashfuse/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libfuse2, zstd, liblz4, liblzo"

termux_step_pre_configure () {
	./autogen.sh
}
