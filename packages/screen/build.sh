TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/screen/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with VT100/ANSI terminal emulation"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.1"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/screen/screen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bca9b5b9022ca7b8c1a61b503e53ace7dd7cb61eac14e39e7ccbc0b139495d49
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

termux_pkg_auto_update() {
	read -r latest < <(curl -fsSL "https://mirrors.kernel.org/gnu/screen" | sed -rn 's/.*screen-([0-9]+(\.[0-9]+)*).*/\1/p' | sort -Vr);
	termux_pkg_upgrade_version "${latest}"
}

termux_step_pre_configure() {
	# Run autoreconf since we have patched configure.ac
	autoreconf -fi
	CFLAGS+=" -DGETUTENT -Dindex=strchr -Drindex=strrchr"
	export LIBS="-ltermux-auth"
}

termux_step_post_configure() {
	echo '#define HAVE_SVR4_PTYS 1' >> "$TERMUX_PKG_BUILDDIR/config.h"
	echo 'mousetrack on' > "$TERMUX_PREFIX/etc/screenrc"
	echo 'truecolor on' >> "$TERMUX_PREFIX/etc/screenrc"
}
