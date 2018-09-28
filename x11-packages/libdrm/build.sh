TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://dri.freedesktop.org
TERMUX_PKG_DESCRIPTION="Userspace interface to kernel DRM services"
TERMUX_PKG_VERSION=2.4.94
TERMUX_PKG_SRCURL=https://dri.freedesktop.org/libdrm/libdrm-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b73c59b0a3760502c428ba81de49cd4807657d26be5e697eba3a87dd021d16be

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-intel
--disable-radeon
--disable-amdgpu
--disable-nouveau
--disable-vmwgfx
"

termux_step_pre_configure () {
    CFLAGS="${CFLAGS} -DANDROID"
}
