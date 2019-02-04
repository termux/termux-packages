TERMUX_PKG_HOMEPAGE=https://www.qemu.org
TERMUX_PKG_DESCRIPTION="A generic and open source machine emulator (x86_64)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.qemu.org/qemu-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6a0508df079a0a33c2487ca936a56c12122f105b8a96a44374704bef6c69abfc
TERMUX_PKG_DEPENDS="attr, glib, libandroid-shmem, libbz2, libc++, libcap, libcurl, libgnutls, libjpeg-turbo, liblzo, libnettle, libpixman, libpng, libsasl, libssh2, libutil, ncurses, qemu-common, sdl2"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_RM_AFTER_INSTALL="
bin/qemu-nbd
share/man/man8
"

termux_step_configure() {
	local ENABLED_TARGETS="aarch64-softmmu,arm-softmmu,i386-softmmu,riscv32-softmmu,riscv64-softmmu,x86_64-softmmu,aarch64-linux-user,arm-linux-user,i386-linux-user,riscv32-user,riscv64-user,x86_64-linux-user"

	./configure \
		--prefix="${TERMUX_PREFIX}" --cross-prefix="${CC//clang}" \
		--cc="${CC}" --host-cc="gcc" --cxx="${CXX}" --objcc="${CC}" \
		--extra-cflags="${CFLAGS}" --extra-cxxflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS} -landroid-shmem -llog" \
		--smbd="${TERMUX_PREFIX}/bin/smbd" \
		--interp-prefix="${TERMUX_PREFIX}/gnemul" \
		--disable-guest-agent --enable-pie --enable-sdl \
		--with-sdlabi="2.0" --disable-gtk --disable-vte \
		--enable-curses --enable-vnc --enable-vnc-jpeg \
		--enable-vnc-png --enable-vnc-sasl --disable-mpath \
		--disable-xen --enable-curl --enable-fdt \
		--disable-kvm --disable-hax --disable-spice \
		--enable-lzo --enable-bzip2 --disable-seccomp \
		--enable-coroutine-pool --enable-virtfs \
		--enable-tpm --enable-libssh2 --disable-jemalloc \
		--disable-libxml2 --target-list="${ENABLED_TARGETS}"
}

termux_step_post_make_install() {
	## by default, alias 'qemu' will be a qemu-system-x86_64
	ln -sfr "${TERMUX_PREFIX}/bin/qemu-system-x86_64" "${TERMUX_PREFIX}/bin/qemu"
	sed -i 's/qemu\\-system\\-i386/qemu\\-system\\-x86_64/g' "${TERMUX_PREFIX}/share/man/man1/qemu.1"

	## symlink manpages
	ln -sfr "${TERMUX_PREFIX}/share/man/man1/qemu.1" "${TERMUX_PREFIX}/share/man/man1/qemu-system-aarch64.1"
	ln -sfr "${TERMUX_PREFIX}/share/man/man1/qemu.1" "${TERMUX_PREFIX}/share/man/man1/qemu-system-arm.1"
	ln -sfr "${TERMUX_PREFIX}/share/man/man1/qemu.1" "${TERMUX_PREFIX}/share/man/man1/qemu-system-i386.1"
	ln -sfr "${TERMUX_PREFIX}/share/man/man1/qemu.1" "${TERMUX_PREFIX}/share/man/man1/qemu-system-x86_64.1"
}
