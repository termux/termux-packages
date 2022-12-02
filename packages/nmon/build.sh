TERMUX_PKG_HOMEPAGE=https://nmon.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Curses based Performance Monitor for Linux with saving performance stats to a CSV file mode"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=16n
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/nmon/lmon${TERMUX_PKG_VERSION}.c
TERMUX_PKG_SHA256=c0012cc2d925dee940c37ceae297abac64ba5a5c30e575e7418b04028613f5f2
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	local src=$TERMUX_PKG_CACHEDIR/$(basename $TERMUX_PKG_SRCURL)
	termux_download $TERMUX_PKG_SRCURL ${src} $TERMUX_PKG_SHA256
	mkdir -p $TERMUX_PKG_SRCDIR
	cp ${src} $TERMUX_PKG_SRCDIR
}

termux_step_pre_configure() {
	case $TERMUX_ARCH in
		aarch64 | arm ) CPPFLAGS+=" -DARM" ;;
		* ) CPPFLAGS+=" -DX86" ;;
	esac
}

termux_step_make() {
	local src=$(basename $TERMUX_PKG_SRCURL)
	$CC $CFLAGS $CPPFLAGS ${src} -o nmon $LDFLAGS -lncurses -lm
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin nmon
}
