TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://dri.freedesktop.org
TERMUX_PKG_DESCRIPTION="Userspace interface to kernel DRM services"
TERMUX_PKG_VERSION=2.4.92
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://dri.freedesktop.org/libdrm/libdrm-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e9e48fdb4de139dc4d9880aa1473158a16ff6aff63d14341367bd30a51ff39fa

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
