TERMUX_PKG_HOMEPAGE=https://github.com/georgmartius/vid.stab
TERMUX_PKG_DESCRIPTION="video stabilization library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/georgmartius/vid.stab/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9001b6df73933555e56deac19a0f225aae152abbc0e97dc70034814a1943f3d4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DSSE2_FOUND=OFF"

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
}
