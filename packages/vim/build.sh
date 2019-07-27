TERMUX_PKG_HOMEPAGE=https://www.vim.org
TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_LICENSE="VIM License"
TERMUX_PKG_DEPENDS="libiconv, ncurses, vim-runtime"
TERMUX_PKG_RECOMMENDS="diffutils"
# vim should only be updated every 50 releases on multiples of 50.
# Update both vim and vim-python to the same version in one PR.
TERMUX_PKG_VERSION=8.1.1750
TERMUX_PKG_SRCURL="https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=64bd558f12faddd530e7e35f23cf913a6a577b7080d9bb683632d7ee979c2e60
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_tgetent=zero
vim_cv_toupper_broken=no
vim_cv_tty_group=world
--enable-gui=no
--enable-multibyte
--with-features=huge
--without-x
--with-tlib=ncursesw
"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/rview
bin/rvim
bin/ex
share/man/man1/evim.1
share/icons
share/vim/vim81/spell/en.ascii*
share/vim/vim81/print
share/vim/vim81/tools
"
TERMUX_PKG_CONFFILES="share/vim/vimrc"

TERMUX_PKG_CONFLICTS="vim-python"

termux_step_pre_configure() {
	make distclean

	# Remove eventually existing symlinks from previous builds so that they get re-created
	for b in rview rvim ex view vimdiff; do rm -f $TERMUX_PREFIX/bin/$b; done
	rm -f $TERMUX_PREFIX/share/man/man1/view.1
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/vimrc $TERMUX_PREFIX/share/vim/vimrc

	# Remove most tutor files:
	cp $TERMUX_PREFIX/share/vim/vim81/tutor/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PKG_TMPDIR/
	rm -f $TERMUX_PREFIX/share/vim/vim81/tutor/*
	cp $TERMUX_PKG_TMPDIR/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PREFIX/share/vim/vim81/tutor/

	cd $TERMUX_PREFIX/bin
	ln -f -s vim vi
}
