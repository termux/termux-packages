TERMUX_PKG_HOMEPAGE=https://vifm.info/
TERMUX_PKG_DESCRIPTION="File manager with vi like keybindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_SHA256=f5e6add7b0c8221fc5eb5b60c7ea483a141769afea2167f1535d66785bb654ec
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
