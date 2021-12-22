TERMUX_PKG_HOMEPAGE=https://www.xvid.com/
TERMUX_PKG_DESCRIPTION="High performance and high quality MPEG-4 library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.7
TERMUX_PKG_SRCURL=https://downloads.xvid.com/downloads/xvidcore-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=abbdcbd39555691dd1c9b4d08f0a031376a3b211652c0d8b3b8aa9be1303ce2d
TERMUX_PKG_BREAKS="xvidcore-dev"
TERMUX_PKG_REPLACES="xvidcore-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	rm -f $TERMUX_PREFIX/lib/libxvid*
	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/build/generic
	export TERMUX_PKG_SRCDIR=$TERMUX_PKG_BUILDDIR

	if [ $TERMUX_ARCH = i686 ]; then
		# Avoid text relocations:
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-assembly"
	fi
}

