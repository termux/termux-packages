TERMUX_PKG_HOMEPAGE=https://dri.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Userspace interface to kernel DRM services"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.4.99
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://dri.freedesktop.org/libdrm/libdrm-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=4dbf539c7ed25dbb2055090b77ab87508fc46be39a9379d15fed4b5517e1da5e

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-intel
--disable-radeon
--disable-amdgpu
--disable-nouveau
--disable-vmwgfx
"

termux_step_pre_configure() {
	CFLAGS="${CFLAGS} -DANDROID"
}
