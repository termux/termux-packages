TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/libopenraw/exempi
TERMUX_PKG_DESCRIPTION="XMP metadata handling library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="2.6.6"
TERMUX_PKG_SRCURL=https://libopenraw.freedesktop.org/download/exempi-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7513b7e42c3bd90a58d77d938c60d2e87c68f81646e7cb8b12d71fe334391c6f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libexpat, libiconv, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-unittest=no"

termux_step_pre_configure() {
	# libtool links shared libs with -nostdlib but misses the builtins
	# archive, leaving compiler helpers undefined.
	LDFLAGS+=" $($CXX -print-libgcc-file-name)"
}
