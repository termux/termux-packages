TERMUX_PKG_HOMEPAGE=http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html
TERMUX_PKG_DESCRIPTION="Library that allow users to edit command lines as they are typed in"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
_MAIN_VERSION=7.0
_PATCH_VERSION=3
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/readline/readline-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_SHA256=750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-curses --enable-multibyte bash_cv_wcwidth_broken=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="SHLIB_LIBS=-lncursesw"

termux_step_pre_configure () {
	local PATCH_CHECKSUMS
	PATCH_CHECKSUMS[1]=9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376
	PATCH_CHECKSUMS[2]=8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58
	PATCH_CHECKSUMS[3]=9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780
	for patch_number in `seq -f '%03g' ${_PATCH_VERSION}`; do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/readline_patch_${patch_number}.patch
		termux_download \
			"https://mirrors.kernel.org/gnu/readline/readline-7.0-patches/readline70-$patch_number" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[patch_number]}
		patch -p0 -i $PATCHFILE
	done
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig
	cp readline.pc $TERMUX_PREFIX/lib/pkgconfig/
}
