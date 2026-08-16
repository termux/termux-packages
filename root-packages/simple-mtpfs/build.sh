TERMUX_PKG_HOMEPAGE=https://github.com/phatina/simple-mtpfs
TERMUX_PKG_DESCRIPTION="Simple MTP fuse filesystem driver"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@flipphoneguy"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_SRCURL=https://github.com/phatina/simple-mtpfs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1d011df3fa09ad0a5c09d48d84c03e6cddf86390af9eb4e0c178193f32f0e2fc
TERMUX_PKG_DEPENDS="libmtp, libfuse2, libusb"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tmpdir=$TERMUX_PREFIX/tmp"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	echo
	echo "Before using simple-mtpfs, you need to use this command to disable the system default MTP daemon:"
	echo "  sudo /system/bin/am force-stop com.android.mtp"
	echo
	EOF
}
