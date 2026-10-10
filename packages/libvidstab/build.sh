TERMUX_PKG_HOMEPAGE=https://github.com/georgmartius/vid.stab
TERMUX_PKG_DESCRIPTION="video stabilization library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.2"
TERMUX_PKG_SRCURL=https://github.com/georgmartius/vid.stab/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=96db34d48a9e3aa13736a48744b56dfb76731ac9bb5193c716de8534c9fd709d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DSSE2_FOUND=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
}
