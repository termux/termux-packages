TERMUX_PKG_HOMEPAGE=https://www.qemu.org
TERMUX_PKG_DESCRIPTION="A generic and open source machine emulator and virtualizer (headless)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:7.2.0
TERMUX_PKG_SRCURL=https://download.qemu.org/qemu-${TERMUX_PKG_VERSION:2}.tar.xz
TERMUX_PKG_SHA256=5b49ce2687744dad494ae90a898c52204a3406e84d072482a1e1be854eeb2157
TERMUX_PKG_DEPENDS="glib, libbz2, libc++, libcurl, libgnutls, libiconv, libjpeg-turbo, liblzo, libnettle, libnfs, libpixman, libpng, libslirp, libspice-server, libssh, libusb, libusbredir, ncurses, pulseaudio, qemu-common, resolv-conf, zlib, zstd"

# Required by configuration script, but I can't find any binary that uses it.
TERMUX_PKG_BUILD_DEPENDS="libtasn1"

TERMUX_PKG_CONFLICTS="qemu-system-x86_64-headless"
TERMUX_PKG_REPLACES="qemu-system-x86_64-headless"
TERMUX_PKG_PROVIDES="qemu-system-x86_64-headless"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Workaround for https://github.com/termux/termux-packages/issues/12261.
	if [ $TERMUX_ARCH = "aarch64" ]; then
		rm -f $TERMUX_PKG_BUILDDIR/_lib
		mkdir -p $TERMUX_PKG_BUILDDIR/_lib

		cd $TERMUX_PKG_BUILDDIR
		mkdir -p _setjmp-aarch64
		pushd _setjmp-aarch64
		mkdir -p private
		local s
		for s in $TERMUX_PKG_BUILDER_DIR/setjmp-aarch64/{setjmp.S,private-*.h}; do
			local f=$(basename ${s})
			cp ${s} ./${f/-//}
		done
		$CC $CFLAGS $CPPFLAGS -I. setjmp.S -c
		$AR cru $TERMUX_PKG_BUILDDIR/_lib/libandroid-setjmp.a setjmp.o
		popd

		LDFLAGS+=" -L$TERMUX_PKG_BUILDDIR/_lib -l:libandroid-setjmp.a"
	fi
}

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
	QEMU_TARGETS+="x86_64-softmmu,"

	# User mode emulation.
	QEMU_TARGETS+="aarch64-linux-user,"
	QEMU_TARGETS+="arm-linux-user,"
	QEMU_TARGETS+="i386-linux-user,"
	QEMU_TARGETS+="m68k-linux-user,"
	QEMU_TARGETS+="ppc64-linux-user,"
	QEMU_TARGETS+="ppc-linux-user,"
	QEMU_TARGETS+="riscv32-linux-user,"
	QEMU_TARGETS+="riscv64-linux-user,"
	QEMU_TARGETS+="x86_64-linux-user"

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
		--audio-drv-list=pa \
		--enable-trace-backends=nop \
		--enable-guest-agent \
		--enable-gnutls \
		--enable-nettle \
		--disable-sdl \
		--disable-sdl-image \
		--disable-gtk \
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
		--enable-slirp \
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
