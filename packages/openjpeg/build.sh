TERMUX_PKG_HOMEPAGE=http://www.openjpeg.org/
TERMUX_PKG_DESCRIPTION="JPEG 2000 image compression library"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_SRCURL=https://github.com/uclouvain/openjpeg/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=openjpeg-$TERMUX_PKG_VERSION
TERMUX_PKG_RM_AFTER_INSTALL="lib/openjpeg-2.1/*.cmake"

termux_step_pre_configure () {
	# Force symlinks to be overwritten:
	rm -Rf $TERMUX_PREFIX/lib/libopenjp2.so*
}
