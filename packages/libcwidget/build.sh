TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/cwidget-team/
TERMUX_PKG_DESCRIPTION="high-level terminal interface library for C++"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.18
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/c/cwidget/cwidget_$TERMUX_PKG_VERSION.orig.tar.xz
TERMUX_PKG_SHA256=a2fb48ff86e41fe15072e6d87b9467ff3af57329586f4548d9f25cf50491c9fc
TERMUX_PKG_DEPENDS="ncurses, libiconv, libsigc++-2.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-werror"

termux_step_pre_configure() {
	CXXFLAGS+=" -DNCURSES_WIDECHAR=1"
	LDFLAGS+=" -liconv"

	if [ $TERMUX_ARCH = aarch64 ] || [ $TERMUX_ARCH = arm ]; then
		LDFLAGS+=" $($CC -print-libgcc-file-name)"
	fi
}
