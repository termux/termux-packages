TERMUX_PKG_HOMEPAGE=https://www.qemu.org
TERMUX_PKG_DESCRIPTION="A generic and open source machine emulator and virtualizer"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
# Do not update version unless you verified that it works properly.
_PACKAGE_VERSION=4.1.1
TERMUX_PKG_VERSION=1:${_PACKAGE_VERSION}
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://download.qemu.org/qemu-${_PACKAGE_VERSION}.tar.xz
TERMUX_PKG_SHA256="ed6fdbbdd272611446ff8036991e9b9f04a2ab2e3ffa9e79f3bab0eb9a95a1d2"
TERMUX_PKG_DEPENDS="attr, glib, libbz2, libc++, libcap, libcurl, libandroid-shmem, libgcrypt, libiconv, libjpeg-turbo, liblzo, libnfs, libpixman, libpng, libssh, libx11, libxml2, ncurses, qemu-common, resolv-conf, sdl2, sdl2-image, zlib"
TERMUX_PKG_CONFLICTS="qemy-system-x86_64-headless"
TERMUX_PKG_BUILD_IN_SRC=true

# Remove files already present in qemu-utils and qemu-common.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/elf2dmp
bin/qemu-edid
bin/qemu-img
bin/qemu-io
bin/qemu-nbd
bin/qemu-pr-helper
bin/virtfs-proxy-helper
libexec/qemu-bridge-helper
share/applications
share/icons
share/doc
share/man/man1/qemu.1*
share/man/man1/qemu-img.1*
share/man/man1/virtfs-proxy-helper.1*
share/man/man7
share/man/man8/qemu-nbd.8*
share/qemu
"

termux_step_configure() {
	local QEMU_TARGETS=""

	# System emulation.
	QEMU_TARGETS+="aarch64-softmmu,"
	QEMU_TARGETS+="arm-softmmu,"
	QEMU_TARGETS+="i386-softmmu,"
	QEMU_TARGETS+="riscv32-softmmu,"
	QEMU_TARGETS+="riscv64-softmmu,"
	QEMU_TARGETS+="x86_64-softmmu"

	CFLAGS+=" $CPPFLAGS"
	CXXFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -landroid-shmem -llog"

	cp "$TERMUX_PREFIX"/bin/libgcrypt-config \
		"$TERMUX_PKG_TMPDIR"/libgcrypt-config
	export PATH="$PATH:$TERMUX_PKG_TMPDIR"

	# Note: using --disable-stack-protector since stack protector
	# flags already passed by build scripts but we do not want to
	# override them with what QEMU configure provides.
	./configure \
		--prefix="$TERMUX_PREFIX" \
		--cross-prefix="${TERMUX_HOST_PLATFORM}-" \
		--host-cc="gcc" \
		--cc="$CC" \
		--cxx="$CXX" \
		--objcc="$CC" \
		--disable-stack-protector \
		--smbd="$TERMUX_PREFIX/bin/smbd" \
		--enable-coroutine-pool \
		--audio-drv-list=sdl \
		--enable-trace-backends=nop \
		--disable-guest-agent \
		--disable-gnutls \
		--disable-nettle \
		--enable-gcrypt \
		--enable-sdl \
		--enable-sdl-image \
		--disable-gtk \
		--disable-vte \
		--enable-curses \
		--enable-iconv \
		--enable-vnc \
		--disable-vnc-sasl \
		--enable-vnc-jpeg \
		--enable-vnc-png \
		--disable-xen \
		--disable-xen-pci-passthrough \
		--enable-virtfs \
		--enable-curl \
		--enable-fdt \
		--disable-kvm \
		--disable-hax \
		--disable-hvf \
		--disable-whpx \
		--enable-libnfs \
		--disable-libusb \
		--enable-lzo \
		--disable-snappy \
		--enable-bzip2 \
		--disable-lzfse \
		--disable-seccomp \
		--enable-libssh \
		--enable-libxml2 \
		--enable-bochs \
		--enable-cloop \
		--enable-dmg \
		--enable-parallels \
		--enable-qed \
		--enable-sheepdog \
		--target-list="$QEMU_TARGETS"
}

termux_step_post_make_install() {
	local i
	for i in aarch64 arm i386 riscv32 riscv64 x86_64; do
		ln -sfr \
			"${TERMUX_PREFIX}"/share/man/man1/qemu.1 \
			"${TERMUX_PREFIX}"/share/man/man1/qemu-system-${i}.1
	done
}
