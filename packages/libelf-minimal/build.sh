TERMUX_PKG_HOMEPAGE=https://github.com/arachsys/libelf/
TERMUX_PKG_DESCRIPTION="Freestanding libelf extracted from elfutils"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.192.1"
TERMUX_PKG_SRCURL="https://github.com/arachsys/libelf/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a359755a54200e0d9fab4bf169d5af7d2177d12b324874c6c32eaac5cce79295
TERMUX_PKG_BUILD_DEPENDS="zlib, zstd"
TERMUX_PKG_DEPENDS="zlib, zstd"
TERMUX_PKG_CONFLICTS="libelf-dev, libelf"
TERMUX_PKG_REPLACES="libelf-dev, libelf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
	make -j $TERMUX_PKG_MAKE_PROCESSES PREFIX=$PREFIX PKG_CONFIG=$PKG_CONFIG
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR
	# don't install static
	make -j $TERMUX_PKG_MAKE_PROCESSES install-headers \
		install-shared install-pc PREFIX=$PREFIX
}
