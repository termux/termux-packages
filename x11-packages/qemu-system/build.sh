TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://www.qemu.org
TERMUX_PKG_DESCRIPTION="A generic and open source machine emulator and virtualizer (i386, x86_64 targets)"
TERMUX_PKG_VERSION=2.12.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://download.qemu.org/qemu-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e69301f361ff65bf5dabd8a19196aeaa5613c1b5ae1678f0823bdf50e7d5c6fc
TERMUX_PKG_DEPENDS="glib, libandroid-shmem, libandroid-support, libbz2, libc++, libcurl, libgnutls, libjpeg-turbo, liblzo, libnettle, libpixman, libpng, libsasl, libsdl, libssh2, libutil, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/qemu-nbd
share/man/man8
"

termux_step_configure()
{
    ./configure --prefix="${TERMUX_PREFIX}" \
                --cross-prefix="${CC//clang}" \
                --cc="${CC}" \
                --host-cc="gcc" \
                --cxx="${CXX}" \
                --objcc="${CC}" \
                --extra-cflags="${CFLAGS}" \
                --extra-cxxflags="${CXXFLAGS}" \
                --extra-ldflags="${LDFLAGS} -landroid-shmem -llog" \
                --smbd="${TERMUX_PREFIX}/bin/smbd" \
                --disable-guest-agent \
                --enable-pie \
                --disable-gtk \
                --disable-vte \
                --enable-curses \
                --enable-vnc \
                --enable-vnc-jpeg \
                --enable-vnc-png \
                --enable-vnc-sasl \
                --disable-mpath \
                --disable-xen \
                --enable-curl \
                --enable-fdt \
                --disable-kvm \
                --disable-hax \
                --disable-spice \
                --enable-lzo \
                --enable-bzip2 \
                --disable-seccomp \
                --enable-coroutine-pool \
                --enable-tpm \
                --enable-libssh2 \
                --disable-jemalloc \
                --disable-libxml2 \
                --target-list=aarch64-softmmu,arm-softmmu,i386-softmmu,x86_64-softmmu
}

termux_step_post_make_install()
{
    ## by default, alias 'qemu' will be a qemu-system-x86_64
    ln -sfr "${TERMUX_PREFIX}/bin/qemu-system-x86_64" "${TERMUX_PREFIX}/bin/qemu"
    sed -i 's/qemu\\-system\\-i386/qemu\\-system\\-x86_64/g' "${TERMUX_PREFIX}/share/man/man1/qemu.1"

    ## symlink manpages
    ln -sfr "${TERMUX_PREFIX}/share/man/man1/qemu.1" "${TERMUX_PREFIX}/share/man/man1/qemu-system-aarch64.1"
    ln -sfr "${TERMUX_PREFIX}/share/man/man1/qemu.1" "${TERMUX_PREFIX}/share/man/man1/qemu-system-arm.1"
    ln -sfr "${TERMUX_PREFIX}/share/man/man1/qemu.1" "${TERMUX_PREFIX}/share/man/man1/qemu-system-i386.1"
    ln -sfr "${TERMUX_PREFIX}/share/man/man1/qemu.1" "${TERMUX_PREFIX}/share/man/man1/qemu-system-x86_64.1"
}
