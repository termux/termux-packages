TERMUX_PKG_HOMEPAGE=https://github.com/radareorg/cutter
TERMUX_PKG_VERSION=1.0-alpha
TERMUX_PKG_SRCURL=https://github.com/radareorg/cutter/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=58ea937709637d59089c6656eaa276d0863dd96142afb97bab797c834bb4c085
TERMUX_PKG_DEPENDS="qt5, radare2"

termux_step_pre_configure () {
	export TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/src"
}

termux_step_make_install () {
	cp $TERMUX_PKG_BUILDDIR/cutter $TERMUX_PREFIX/bin/cutter
}
