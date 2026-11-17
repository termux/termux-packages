TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/dav1d/
TERMUX_PKG_DESCRIPTION="AV1 cross-platform decoder focused on speed and correctness"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.5"
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/dav1d/-/archive/${TERMUX_PKG_VERSION}/dav1d-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=afc5378daba30eafd11d7b4f0ec863270d7b175f38393a2e1e0ff76f3a45c8b9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_tools=true
-Denable_tests=false
"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "i686" ]; then
		# Avoid text relocations.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Denable_asm=false"
	fi
}
