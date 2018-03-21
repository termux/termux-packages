TERMUX_PKG_HOMEPAGE=https://xiph.org/flac/
TERMUX_PKG_DESCRIPTION="FLAC (Free Lossless Audio Codec) library"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz
TERMUX_PKG_SHA256=4773c0099dba767d963fd92143263be338c48702172e8754b9bc5103efe1c56c
TERMUX_PKG_DEPENDS="libogg"

termux_step_pre_configure () {
	if [ "$TERMUX_DEBUG" == "true" ]; then
		# libflac does removes the flag "-g" from CFLAGS in the configure script
		# Not sure why this is done but lets assume there is a good reason for it.
		# -g3 is normally passed for a debug build in termux, -g is then removed
		# and only "3" is left which isn't a valid option to the compiler.
		export CFLAGS="${CFLAGS/-g3/}"
	fi
}
