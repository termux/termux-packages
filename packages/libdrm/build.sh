TERMUX_PKG_HOMEPAGE=https://dri.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Userspace interface to kernel DRM services"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.123"
TERMUX_PKG_SRCURL=https://dri.freedesktop.org/libdrm/libdrm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a2b98567a149a74b0f50e91e825f9c0315d86e7be9b74394dae8b298caadb79e
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintel=disabled
-Dradeon=disabled
-Damdgpu=disabled
-Dnouveau=disabled
-Dvmwgfx=disabled
-Dtests=false
"

termux_step_pre_configure() {
	CFLAGS="${CFLAGS} -DANDROID"
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}
