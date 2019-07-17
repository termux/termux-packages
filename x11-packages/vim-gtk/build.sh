TERMUX_PKG_HOMEPAGE=https://www.vim.org
TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_LICENSE="VIM License"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"

# vim should only be updated every 50 releases on multiples of 50.
TERMUX_PKG_VERSION=8.1.1450
TERMUX_PKG_REVISION=1

TERMUX_PKG_SRCURL=https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf7837109b37d4426fd575a8f04e11f6485fabb072b799811cf868e400720490
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo-x, libice, libiconv, liblua, libsm, libx11, libxpm, libxt, ncurses, pango-x, python"
TERMUX_PKG_CONFLICTS="vim, vim-python, vim-runtime"
TERMUX_PKG_BUILD_IN_SRC="yes"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_small_wchar_t=no
vi_cv_path_python3_pfx=$TERMUX_PREFIX
vi_cv_var_python3_version=3.7
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_tgetent=zero
vim_cv_toupper_broken=no
vim_cv_tty_group=world
--enable-cscope
--enable-gui=gtk3
--enable-multibyte
--enable-luainterp
--enable-python3interp
--with-features=huge
--with-lua-prefix=$TERMUX_PREFIX
--with-python3-config-dir=$TERMUX_PREFIX/lib/python3.7/config-3.7m/
--with-tlib=ncursesw
--with-x"

TERMUX_PKG_RM_AFTER_INSTALL="
share/vim/vim81/spell/en.ascii*
share/vim/vim81/print
share/vim/vim81/tools"

TERMUX_PKG_CONFFILES="share/vim/vimrc"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"

	make distclean

	# Remove eventually existing symlinks from previous builds so that they get re-created.
	for link in eview evim ex gview gvim gvimdiff rgview rgvim rview rvim view vimdiff; do
		rm -f $TERMUX_PREFIX/bin/$link
		rm -f $TERMUX_PREFIX/share/man/man1/${link}.1*
	done
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/vimrc $TERMUX_PREFIX/share/vim/vimrc
	ln -sfr $TERMUX_PREFIX/bin/vim $TERMUX_PREFIX/bin/vi
}
