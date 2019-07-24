TERMUX_PKG_HOMEPAGE=https://vifm.info/
TERMUX_PKG_DESCRIPTION="File manager with vi like keybindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.10
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=e5681c9e560e23d9deeec3b5b12e0ccad82612d9592c00407f3dd75cf5066548
TERMUX_PKG_SRCURL=https://github.com/vifm/vifm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses, file"

termux_step_pre_configure() {
	autoreconf -if
	if [ "$TERMUX_DEBUG" == "true" ]; then
		# Debug build fails with:
		# /home/builder/.termux-build/vifm/src/src/fops_common.c:745:27: error: 'umask' called with invalid mode
		#      saved_umask = umask(~0600);
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
