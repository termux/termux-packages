TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/screen/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with VT100/ANSI terminal emulation"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/screen/screen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f04a39d00a0e5c7c86a55338808903082ad5df4d73df1a2fd3425976aed94971
# libandroid-support is necessary as screen uses `wcwidth`, see #22688
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, termux-auth"
TERMUX_PKG_BUILD_DEPENDS="libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-system_screenrc=$TERMUX_PREFIX/etc/screenrc
--disable-socket-dir
--disable-pam
--enable-colors256
"

termux_step_pre_configure() {
	# Run autoreconf since we have patched configure.ac
	autoreconf -fi
	CFLAGS+=" -DGETUTENT -Dindex=strchr -Drindex=strrchr"
	export LIBS="-ltermux-auth"
}

termux_step_post_configure() {
	echo '#define HAVE_SVR4_PTYS 1' >> "$TERMUX_PKG_BUILDDIR/config.h"
	echo 'mousetrack on' > "$TERMUX_PREFIX/etc/screenrc"
}
