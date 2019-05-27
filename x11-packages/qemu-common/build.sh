TERMUX_PKG_HOMEPAGE=https://www.qemu.org
TERMUX_PKG_DESCRIPTION="A set common files for the QEMU emulators"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.qemu.org/qemu-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=13a93dfe75b86734326f8d5b475fde82ec692d5b5a338b4262aeeb6b0fa4e469
TERMUX_PKG_DEPENDS="capstone, dtc, glib, libandroid-shmem, libbz2, libc++, libcap, libcurl, libffi, libgnutls, libjpeg-turbo, liblzo, libnettle, libnfs, libpixman, libpng, libsasl, libssh2, libxml2, ncurses, openssl, pcre, sdl2, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ $TERMUX_PKG_API_LEVEL -lt 24 ]; then
		patch -p1 -i "$TERMUX_PKG_BUILDER_DIR"/android-5/0008-fix-syscalls-android5.patch
		patch -p1 -i "$TERMUX_PKG_BUILDER_DIR"/android-5/0012-implement-lockf.patch
		patch -p1 -i "$TERMUX_PKG_BUILDER_DIR"/android-5/0013-implement-openpty.patch
	else
		patch -p1 -i "$TERMUX_PKG_BUILDER_DIR"/android-7/0008-fix-syscalls-android7.patch
	fi
}

termux_step_configure() {
	local ENABLED_TARGETS

	# System emulators.
	ENABLED_TARGETS+="aarch64-softmmu,"
	ENABLED_TARGETS+="arm-softmmu,"
	ENABLED_TARGETS+="i386-softmmu,"
	ENABLED_TARGETS+="riscv32-softmmu,"
	ENABLED_TARGETS+="riscv64-softmmu,"
	ENABLED_TARGETS+="x86_64-softmmu"

	# Force-link with liblog and libandroid-shmem.
	LDFLAGS+=" -landroid-shmem -llog"

	./configure \
		--prefix="$TERMUX_PREFIX" \
		--host-cc="gcc" \
		--cross-prefix="${CC//clang}" \
		--cc="$CC" \
		--cxx="$CXX" \
		--objcc="$CC" \
		--extra-cflags="$CFLAGS" \
		--extra-cxxflags="$CXXFLAGS" \
		--extra-ldflags="$LDFLAGS" \
		--enable-pie \
		--target-list="$ENABLED_TARGETS" \
		--interp-prefix="$TERMUX_PREFIX/gnemul" \
		--smbd="$TERMUX_PREFIX/bin/smbd" \
		--enable-tools \
		--disable-guest-agent \
		--enable-capstone \
		--enable-coroutine-pool \
		--disable-avx2 \
		--disable-jemalloc \
		--disable-tcmalloc \
		--disable-membarrier \
		--disable-seccomp \
		--disable-linux-aio \
		--disable-numa \
		--disable-brlapi \
		--disable-bluez \
		--disable-netmap \
		--disable-usb-redir \
		--disable-vde \
		--disable-vhost-crypto \
		--disable-vhost-net \
		--disable-vhost-user \
		--disable-vhost-vsock \
		--disable-hax \
		--disable-hvf \
		--disable-kvm \
		--disable-whpx \
		--disable-xen \
		--disable-virglrenderer \
		--enable-curses \
		--disable-gtk \
		--disable-opengl \
		--enable-sdl \
		--disable-vte \
		--enable-vnc \
		--enable-vnc-jpeg \
		--enable-vnc-png \
		--enable-vnc-sasl \
		--disable-spice \
		--disable-crypto-afalg \
		--enable-gnutls \
		--enable-nettle \
		--disable-gcrypt \
		--enable-curl \
		--enable-libnfs \
		--enable-libssh2 \
		--enable-bzip2 \
		--enable-lzo \
		--disable-snappy \
		--disable-glusterfs \
		--disable-libiscsi \
		--disable-libusb \
		--disable-mpath \
		--disable-rbd \
		--enable-virtfs \
		--disable-xfsctl \
		--disable-libpmem \
		--enable-bochs \
		--enable-cloop \
		--enable-dmg \
		--enable-parallels \
		--enable-qcow1 \
		--enable-qed \
		--enable-sheepdog \
		--enable-vdi \
		--enable-vvfat \
		--disable-vxhs \
		--enable-fdt \
		--enable-tpm \
		--disable-smartcard \
		--enable-attr \
		--disable-cap-ng \
		--enable-libxml2
}

termux_step_post_make_install() {
	for i in aarch64 arm i386 riscv32 riscv64 x86_64; do
		ln -sfr \
			"${TERMUX_PREFIX}"/share/man/man1/qemu.1 \
			"${TERMUX_PREFIX}"/share/man/man1/qemu-system-${i}.1
	done
	unset i
}
