TERMUX_PKG_DESCRIPTION="Highly configurable text editor built to enable efficient text editing"
TERMUX_PKG_HOMEPAGE=http://www.vim.org/
TERMUX_PKG_DEPENDS="ncurses, vim-runtime"

# Vim 7.4 patches described at ftp://ftp.vim.org/pub/vim/patches/7.4/README
VIM_MINOR_REVISION=748
VIM_TAGNAME="v7-4-${VIM_MINOR_REVISION}"
TERMUX_PKG_VERSION=7.4.${VIM_MINOR_REVISION}
TERMUX_PKG_SRCURL="https://code.google.com/p/vim/source/browse/?name=$VIM_TAGNAME"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="vim_cv_toupper_broken=no vim_cv_terminfo=yes vim_cv_tty_group=world"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" vim_cv_getcwd_broken=no vim_cv_stat_ignores_slash=no vim_cv_memmove_handles_overlap=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-tlib=ncursesw --enable-multibyte --without-x --enable-gui=no --disable-darwin --with-features=huge"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_RM_AFTER_INSTALL='bin/rview bin/rvim bin/ex share/man/man1/evim.1 share/icons share/vim/vim74/spell/en.ascii* share/vim/vim74/spell/en.latin1* share/vim/vim74/print share/vim/vim74/tools'

termux_step_extract_package () {
	if test ! -d $TERMUX_PKG_CACHEDIR/vim-hg; then
		hg clone https://vim.googlecode.com/hg/ $TERMUX_PKG_CACHEDIR/vim-hg
	fi
	cd $TERMUX_PKG_CACHEDIR/vim-hg
	hg pull -u
	hg update "$VIM_TAGNAME"

	cp -Rf $TERMUX_PKG_CACHEDIR/vim-hg $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
}

termux_step_pre_configure () {
	make distclean

	# Remove eventually existing symlinks from previous builds so that they get re-created
	for b in rview rvim ex view vimdiff; do rm -f $TERMUX_PREFIX/bin/$b; done
	rm -f $TERMUX_PREFIX/share/man/man1/view.1
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/vimrc $TERMUX_PREFIX/share/vim/vimrc

        # Remove most tutor files:
        cp $TERMUX_PREFIX/share/vim/vim74/tutor/tutor.{vim,utf-8} $TERMUX_PKG_TMPDIR/
        rm -f $TERMUX_PREFIX/share/vim/vim74/tutor/*
        cp $TERMUX_PKG_TMPDIR/tutor.{vim,utf-8} $TERMUX_PREFIX/share/vim/vim74/tutor/
}
