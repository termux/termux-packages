TERMUX_PKG_HOMEPAGE=https://nmon.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Curses based Performance Monitor for Linux with saving performance stats to a CSV file mode"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="16q"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/nmon/lmon${TERMUX_PKG_VERSION}.c
TERMUX_PKG_SHA256=1b78a81672c19291b3d11a6e319dd9b23a022a262dba1efcea008d6df51aca51
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	termux_download $TERMUX_PKG_SRCURL $TERMUX_PKG_CACHEDIR/lmon.c $TERMUX_PKG_SHA256
	mkdir -p $TERMUX_PKG_SRCDIR
	cp $TERMUX_PKG_CACHEDIR/lmon.c $TERMUX_PKG_SRCDIR
}

termux_step_pre_configure() {
	case $TERMUX_ARCH in
		aarch64 | arm ) CPPFLAGS+=" -DARM" ;;
		* ) CPPFLAGS+=" -DX86" ;;
	esac
}

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS $TERMUX_PKG_SRCDIR/lmon.c -o nmon $LDFLAGS -lncurses -lm
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin nmon
}
