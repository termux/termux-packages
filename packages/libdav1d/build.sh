TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/dav1d/
TERMUX_PKG_DESCRIPTION="AV1 cross-platform decoder focused on speed and correctness"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.2"
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/dav1d/-/archive/${TERMUX_PKG_VERSION}/dav1d-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=18d0c67421fac213b680a26856dd74ae7bb28b9ff59edd6f6580864d2b71d1ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_tools=false
-Denable_tests=false
"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "i686" ]; then
		# Avoid text relocations.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Denable_asm=false"
	fi
}
