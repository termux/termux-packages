TERMUX_PKG_HOMEPAGE=https://github.com/vasi/squashfuse
TERMUX_PKG_DESCRIPTION="FUSE filesystem to mount squashfs archives"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.0"
TERMUX_PKG_SRCURL=https://github.com/vasi/squashfuse/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93ef7fc5d359d5a8faf284232bbf351ce5630de4234c9655445803030f7e1bc5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libfuse2, liblz4, liblzma, liblzo, zlib, zstd"

termux_step_pre_configure () {
	./autogen.sh
}
