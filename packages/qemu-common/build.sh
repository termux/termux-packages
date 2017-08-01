TERMUX_PKG_HOMEPAGE=http://www.qemu.org
TERMUX_PKG_DESCRIPTION="Qemu fast processor emulator - common files"
TERMUX_PKG_VERSION=2.12.0
TERMUX_PKG_SRCURL=http://download.qemu-project.org/qemu-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e69301f361ff65bf5dabd8a19196aeaa5613c1b5ae1678f0823bdf50e7d5c6fc
TERMUX_PKG_DEPENDS="glib, libutil, liblzo, libbz2, libnettle, ncurses, libjpeg-turbo, libcurl, libandroid-shmem, libpulseaudio, libsasl, libgnutls, libspice-server, libspice-protocol, libpixman, libpng"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man8/qemu-nbd.8"

termux_step_configure () {
	# Unfortunately for now we have to disable sound-oss, sound-alsa,
	# sound-sdl, KVM, seccomp, snappy, sparse, gtk, vte, sdl, vde,
	# netmap, cap-ng, brlapi, bluez, rbd, libssh2, AIO, OpenGL, iSCSI,
	# smartcard, libusb, usb-redir, nfs, VirtFS, guest-agent-msi,
	# hax, virglrenderer
	"$TERMUX_PKG_SRCDIR/configure" \
	    --prefix=$TERMUX_PREFIX \
	    --cross-prefix=${TERMUX_HOST_PLATFORM}- \
	    --audio-drv-list="pa" \
	    --disable-kvm \
	    --disable-seccomp \
	    --disable-snappy \
	    --disable-sparse \
	    --disable-gtk \
	    --disable-sdl \
	    --disable-vde \
	    --disable-netmap \
	    --disable-bluez \
	    --disable-rbd \
	    --disable-libssh2 \
	    --disable-linux-aio \
	    --disable-opengl \
	    --disable-glusterfs \
	    --disable-libiscsi \
	    --disable-smartcard \
	    --disable-libusb \
	    --disable-usb-redir \
	    --disable-virglrenderer \
	    --disable-libnfs \
	    --disable-virtfs \
	    --disable-guest-agent-msi \
	    --disable-hax \
	    --enable-lzo \
	    --enable-vnc-jpeg \
	    --smbd=$TERMUX_PREFIX/usr/sbin/smbd \
	    --enable-system \
	    --disable-user \
	    --disable-linux-user \
	    --disable-bsd-user \
	    --enable-docs \
	    --enable-guest-agent \
	    --enable-pie \
	    --enable-gnutls \
	    --enable-modules \
	    --enable-nettle \
	    --enable-curses \
	    --disable-gcrypt \
	    --enable-spice \
	    --enable-vnc \
	    --enable-vnc-jpeg \
	    --enable-vnc-png \
	    --enable-vnc-sasl \
	    --disable-cocoa \
	    --disable-xen \
	    --disable-xen-pci-passthrough \
	    --enable-curl \
	    --enable-fdt \
	    --disable-rdma \
	    --enable-attr \
	    --enable-vhost-net \
	    --enable-lzo \
	    --enable-bzip2 \
	    --enable-coroutine-pool \
	    --enable-tpm \
	    --disable-numa \
	    --enable-replication \
	    --enable-vhost-vsock \
	    --enable-qom-cast-debug \
	    --disable-xfsctl \
	    --enable-tools
}

termux_step_make () {
	QEMU_ARCH=${TERMUX_ARCH}
	case ${TERMUX_ARCH} in
		i?86)
			QEMU_ARCH=i386;;
		*)
			QEMU_ARCH="${TERMUX_ARCH}";;
	esac
	make ARCH=${QEMU_ARCH} CROSS_COMPILE=${TERMUX_HOST_PLATFORM}- -j $TERMUX_MAKE_PROCESSES
}

termux_step_pre_configure() {
    LDFLAGS+=" -llog -landroid-shmem"
    LDFLAGS+=" $CPPFLAGS"
}
