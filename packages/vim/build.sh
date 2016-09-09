TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_HOMEPAGE=http://www.vim.org/
TERMUX_PKG_DEPENDS="ncurses, vim-runtime"

# Vim 7.4 patches described at ftp://ftp.vim.org/pub/vim/patches/7.4/README
TERMUX_PKG_VERSION=7.4.2290
TERMUX_PKG_SRCURL="https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_FOLDERNAME=vim-${TERMUX_PKG_VERSION}
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="vim_cv_toupper_broken=no vim_cv_terminfo=yes vim_cv_tty_group=world"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" vim_cv_getcwd_broken=no vim_cv_stat_ignores_slash=no vim_cv_memmove_handles_overlap=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-tlib=ncursesw --enable-multibyte --without-x --enable-gui=no --disable-darwin --with-features=huge"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_RM_AFTER_INSTALL='bin/rview bin/rvim bin/ex share/man/man1/evim.1 share/icons share/vim/vim74/spell/en.ascii* share/vim/vim74/print share/vim/vim74/tools'

TERMUX_PKG_CONFLICTS="vim-python"

termux_step_pre_configure () {
	make distclean

	# Remove eventually existing symlinks from previous builds so that they get re-created
	for b in rview rvim ex view vimdiff; do rm -f $TERMUX_PREFIX/bin/$b; done
	rm -f $TERMUX_PREFIX/share/man/man1/view.1
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/vimrc $TERMUX_PREFIX/share/vim/vimrc

	# Remove most tutor files:
	cp $TERMUX_PREFIX/share/vim/vim74/tutor/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PKG_TMPDIR/
	rm -f $TERMUX_PREFIX/share/vim/vim74/tutor/*
	cp $TERMUX_PKG_TMPDIR/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PREFIX/share/vim/vim74/tutor/

	cd $TERMUX_PREFIX/bin
	ln -f -s vim vi
}
