TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/dav1d/
TERMUX_PKG_DESCRIPTION="AV1 cross-platform decoder focused on speed and correctness"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://downloads.videolan.org/pub/videolan/dav1d/${TERMUX_PKG_VERSION}/dav1d-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=51737db7e4897e599684f873a4725176dd3c779e639411d7c4fce134bb5ebb82
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
