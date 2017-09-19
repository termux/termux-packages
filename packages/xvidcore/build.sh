TERMUX_PKG_HOMEPAGE=http://www.xvid.org/
TERMUX_PKG_DESCRIPTION="High performance and high quality MPEG-4 library"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.xvid.org/downloads/xvidcore-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4e9fd62728885855bc5007fe1be58df42e5e274497591fec37249e1052ae316f
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	rm -f $TERMUX_PREFIX/lib/libxvid*
	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/build/generic
	export TERMUX_PKG_SRCDIR=$TERMUX_PKG_BUILDDIR

	if [ $TERMUX_ARCH = i686 ]; then
		# Avoid text relocations:
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-assembly"
	fi
}

