TERMUX_PKG_HOMEPAGE=http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html
TERMUX_PKG_DESCRIPTION="Library providing a set of functions for use by applications that allow users to edit command lines as they are typed in"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
_MAIN_VERSION=7.0
_PATCH_VERSION=1
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/readline/readline-${_MAIN_VERSION}.tar.gz

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-curses --enable-multibyte bash_cv_wcwidth_broken=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="SHLIB_LIBS=-lncursesw"

termux_step_pre_configure () {
        cd $TERMUX_PKG_SRCDIR
	for patch_number in `seq -f '%03g' ${_PATCH_VERSION}`; do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/readline_patch_${patch_number}.patch
		test ! -f $PATCHFILE && termux_download \
			"https://mirrors.kernel.org/gnu/readline/readline-7.0-patches/readline70-$patch_number" \
			$PATCHFILE
		patch -p0 -i $PATCHFILE
	done
}
