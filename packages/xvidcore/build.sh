TERMUX_PKG_HOMEPAGE=http://www.xvid.org/
TERMUX_PKG_DESCRIPTION="High performance and high quality MPEG-4 library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.3.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=165ba6a2a447a8375f7b06db5a3c91810181f2898166e7c8137401d7fc894cf0
TERMUX_PKG_BREAKS="xvidcore-dev"
TERMUX_PKG_REPLACES="xvidcore-dev"
TERMUX_PKG_SRCURL=http://downloads.xvid.org/downloads/xvidcore-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	rm -f $TERMUX_PREFIX/lib/libxvid*
	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/build/generic
	export TERMUX_PKG_SRCDIR=$TERMUX_PKG_BUILDDIR

	if [ $TERMUX_ARCH = i686 ]; then
		# Avoid text relocations:
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-assembly"
	fi
}

