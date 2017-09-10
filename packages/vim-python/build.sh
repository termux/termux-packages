TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_HOMEPAGE=http://www.vim.org/
TERMUX_PKG_DEPENDS="ncurses, vim-runtime, python"

# Vim 8.0 patches described at ftp://ftp.vim.org/pub/vim/patches/8.0/README
TERMUX_PKG_VERSION=8.0.1092
TERMUX_PKG_SHA256=42f54fda0c0abdff9d82fcd5e12ef0c7c1a57e567b648b52e20c8ab207eb7787
TERMUX_PKG_SRCURL="https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_FOLDERNAME=vim-${TERMUX_PKG_VERSION}
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_tgent=zero
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
share/vim/vim80/spell/en.ascii*
share/vim/vim80/print
share/vim/vim80/tools
"
TERMUX_PKG_CONFFILES="share/vim/vimrc"

# vim-python:
TERMUX_PKG_CONFLICTS="vim"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
vi_cv_path_python3_pfx=$TERMUX_PREFIX
vi_cv_var_python3_version=3.6
--enable-python3interp
--with-python3-config-dir=$TERMUX_PREFIX/lib/python3.6/config-3.6m/
"
TERMUX_PKG_DESCRIPTION+=" - with python support"
termux_step_pre_configure() {
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python3.6m"
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
	cp $TERMUX_PREFIX/share/vim/vim80/tutor/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PKG_TMPDIR/
	rm -f $TERMUX_PREFIX/share/vim/vim80/tutor/*
	cp $TERMUX_PKG_TMPDIR/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PREFIX/share/vim/vim80/tutor/

	cd $TERMUX_PREFIX/bin
	ln -f -s vim vi
}
