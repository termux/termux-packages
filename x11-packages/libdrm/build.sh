TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://dri.freedesktop.org
TERMUX_PKG_DESCRIPTION="Userspace interface to kernel DRM services"
TERMUX_PKG_VERSION=2.4.95
TERMUX_PKG_SRCURL=https://dri.freedesktop.org/libdrm/libdrm-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ef772a51b4bed97a2c243194d9a98da97319e0dbdf800d07773b025aacc895c6

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
