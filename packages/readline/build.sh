TERMUX_PKG_HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html"
TERMUX_PKG_DESCRIPTION="Library that allow users to edit command lines as they are typed in"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BREAKS="bash (<< 5.0), readline-dev"
TERMUX_PKG_REPLACES="readline-dev"
_MAIN_VERSION=8.3
_PATCH_VERSION=1
TERMUX_PKG_VERSION=$_MAIN_VERSION.$_PATCH_VERSION
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/readline/readline-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_SHA256=fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-curses --enable-multibyte bash_cv_wcwidth_broken=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="SHLIB_LIBS=-lncursesw"
TERMUX_PKG_CONFFILES="etc/inputrc"

termux_step_pre_configure() {
	(( _PATCH_VERSION == 0 )) && return
	local PATCH_NUM PATCHFILE
	local -A PATCH_CHECKSUMS=()

	PATCH_CHECKSUMS[001]=21f0a03106dbe697337cd25c70eb0edbaa2bdb6d595b45f83285cdd35bac84de

	for PATCH_NUM in $(seq -f '%03g' ${_PATCH_VERSION}); do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/readline_patch_${PATCH_NUM}.patch
		termux_download \
			"http://mirrors.kernel.org/gnu/readline/readline-$_MAIN_VERSION-patches/readline${_MAIN_VERSION/./}-$PATCH_NUM" \
			"$PATCHFILE" \
			"${PATCH_CHECKSUMS[$PATCH_NUM]}"
		patch -p0 -i "$PATCHFILE"
	done

	CFLAGS+=" -fexceptions"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/lib/pkgconfig"
	cp readline.pc "$TERMUX_PREFIX/lib/pkgconfig/"

	mkdir -p "$TERMUX_PREFIX/etc"
	cp "$TERMUX_PKG_BUILDER_DIR/inputrc" "$TERMUX_PREFIX/etc/"
}
