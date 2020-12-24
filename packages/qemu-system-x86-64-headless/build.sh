TERMUX_PKG_HOMEPAGE=https://www.qemu.org
TERMUX_PKG_DESCRIPTION="A generic and open source machine emulator and virtualizer (headless)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1:5.2.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.qemu.org/qemu-${TERMUX_PKG_VERSION:2}.tar.xz
TERMUX_PKG_SHA256="cb18d889b628fbe637672b0326789d9b0e3b8027e0445b936537c78549df17bc"
TERMUX_PKG_DEPENDS="attr, glib, libbz2, libc++, libcap-ng, libcurl, libgcrypt, libiconv, libjpeg-turbo, liblzo, libnfs, libpixman, libpng, libssh, ncurses, qemu-common, resolv-conf, zlib"
TERMUX_PKG_CONFLICTS="qemu-system-x86_64-headless"
TERMUX_PKG_REPLACES="qemu-system-x86_64-headless"
TERMUX_PKG_PROVIDES="qemu-system-x86_64-headless"
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
	QEMU_TARGETS+="riscv32-softmmu,"
	QEMU_TARGETS+="riscv64-softmmu,"
	QEMU_TARGETS+="x86_64-softmmu,"

	# User mode emulation.
	QEMU_TARGETS+="aarch64-linux-user,"
	QEMU_TARGETS+="arm-linux-user,"
	QEMU_TARGETS+="i386-linux-user,"
	QEMU_TARGETS+="riscv32-linux-user,"
	QEMU_TARGETS+="riscv64-linux-user,"
	QEMU_TARGETS+="x86_64-linux-user"

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
		--enable-trace-backends=nop \
		--disable-guest-agent \
		--disable-gnutls \
		--disable-nettle \
		--enable-gcrypt \
		--disable-sdl \
		--disable-sdl-image \
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
