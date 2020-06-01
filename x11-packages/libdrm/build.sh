TERMUX_PKG_HOMEPAGE=https://dri.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Userspace interface to kernel DRM services"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.4.101
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://dri.freedesktop.org/libdrm/libdrm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ddf31baa8e49473624860bd166ce654dc349873f7a6c7b3305964249315c78a7

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
