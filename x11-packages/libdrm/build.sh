TERMUX_PKG_HOMEPAGE=https://dri.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Userspace interface to kernel DRM services"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.4.102
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://dri.freedesktop.org/libdrm/libdrm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8bcbf9336c28e393d76c1f16d7e79e394a7fce8a2e929d52d3ad7ad8525ba05b

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintel=false
-Dradeon=false
-Damdgpu=false
-Dnouveau=false
-Dvmwgfx=false
"

termux_step_pre_configure() {
	CFLAGS="${CFLAGS} -DANDROID"
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/libdrm $TERMUX_PKG_BUILDER_DIR/LICENSE
}
