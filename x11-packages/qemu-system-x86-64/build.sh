TERMUX_PKG_HOMEPAGE=https://www.qemu.org
TERMUX_PKG_DESCRIPTION="A generic and open source machine emulator and virtualizer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:7.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.qemu.org/qemu-${TERMUX_PKG_VERSION:2}.tar.xz
TERMUX_PKG_SHA256=a0634e536bded57cf38ec8a751adb124b89c776fe0846f21ab6c6728f1cbbbe6
TERMUX_PKG_DEPENDS="glib, gtk3, libbz2, libc++, libcurl, libgnutls, libiconv, libjpeg-turbo, liblzo, libnettle, libnfs, libpixman, libpng, libspice-server, libssh, libusb, libusbredir, libx11, ncurses, pulseaudio, qemu-common, resolv-conf, sdl2, sdl2-image, zlib, zstd"

# Required by configuration script, but I can't find any binary that uses it.
TERMUX_PKG_BUILD_DEPENDS="libtasn1"

# Remove files already present in qemu-utils and qemu-common.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/elf2dmp
bin/qemu-edid
bin/qemu-ga
bin/qemu-img
bin/qemu-io
bin/qemu-nbd
bin/qemu-pr-helper
bin/qemu-storage-daemon
include/*
libexec/virtfs-proxy-helper
libexec/qemu-bridge-helper
share/applications
share/icons
share/doc
share/man/man1/qemu.1*
share/man/man1/qemu-img.1*
share/man/man1/virtfs-proxy-helper.1*
share/man/man7
share/man/man8/qemu-ga.8*
share/man/man8/qemu-nbd.8*
share/man/man8/qemu-pr-helper.8*
share/qemu
"

TERMUX_PKG_CONFLICTS="qemu-system-x86_64, qemu-system-x86_64-headless, qemu-system-x86-64-headless"
TERMUX_PKG_REPLACES="qemu-system-x86_64, qemu-system-x86_64-headless, qemu-system-x86-64-headless"
TERMUX_PKG_PROVIDES="qemu-system-x86_64"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_ninja

	if [ "$TERMUX_ARCH" = "i686" ]; then
		LDFLAGS+=" -latomic"
	fi

	local QEMU_TARGETS=""

	# System emulation.
	QEMU_TARGETS+="aarch64-softmmu,"
	QEMU_TARGETS+="arm-softmmu,"
	QEMU_TARGETS+="i386-softmmu,"
	QEMU_TARGETS+="m68k-softmmu,"
	QEMU_TARGETS+="ppc64-softmmu,"
	QEMU_TARGETS+="ppc-softmmu,"
	QEMU_TARGETS+="riscv32-softmmu,"
	QEMU_TARGETS+="riscv64-softmmu,"
	QEMU_TARGETS+="x86_64-softmmu"

	CFLAGS+=" $CPPFLAGS"
	CXXFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -landroid-shmem -llog"

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
		--audio-drv-list=pa,sdl \
		--enable-trace-backends=nop \
		--enable-guest-agent \
		--enable-gnutls \
		--enable-nettle \
		--enable-sdl \
		--enable-sdl-image \
		--enable-gtk \
		--disable-vte \
		--enable-curses \
		--enable-iconv \
		--enable-vnc \
		--disable-vnc-sasl \
		--enable-vnc-jpeg \
		--enable-png \
		--disable-xen \
		--disable-xen-pci-passthrough \
		--enable-virtfs \
		--enable-curl \
		--enable-fdt \
		--enable-kvm \
		--disable-hax \
		--disable-hvf \
		--disable-whpx \
		--enable-libnfs \
		--enable-lzo \
		--disable-snappy \
		--enable-bzip2 \
		--disable-lzfse \
		--disable-seccomp \
		--enable-libssh \
		--enable-bochs \
		--enable-cloop \
		--enable-dmg \
		--enable-parallels \
		--enable-qed \
		--enable-spice \
		--enable-libusb \
		--enable-usb-redir \
		--disable-vhost-user \
		--disable-vhost-user-blk-server \
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
