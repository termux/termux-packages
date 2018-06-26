TERMUX_PKG_HOMEPAGE=https://xiph.org/flac/
TERMUX_PKG_DESCRIPTION="FLAC (Free Lossless Audio Codec) library"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://downloads.xiph.org/releases/flac/flac-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=91cfc3ed61dc40f47f050a109b08610667d73477af6ef36dcad31c31a4a8d53f
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
