TERMUX_PKG_HOMEPAGE=http://www.vim.org/
TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
# Dependency on perl is temporary, will be removed once dynamic support works
TERMUX_PKG_DEPENDS="ncurses, vim-runtime, perl"
TERMUX_PKG_SUGGESTS="python, ruby, liblua, tcl"
TERMUX_PKG_BUILD_DEPENDS="python, perl, ruby, liblua, tcl"
# vim should only be updated every 50 releases on multiples of 50.
# Update vim, vim-python and vim-full to the same version in one PR.
TERMUX_PKG_VERSION=8.1.0150
TERMUX_PKG_SHA256=d27812bc4fd0a901e0f3c082ef798cfad10f251adcfc6dec2ca8fcea34b2da17
TERMUX_PKG_SRCURL="https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz"
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

# vim-full:
TERMUX_PKG_CONFLICTS="vim, vim-python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
vi_cv_path_python3_pfx=$TERMUX_PREFIX
vi_cv_var_python3_version=3.6

vi_cv_path_tcl=$TERMUX_PREFIX/bin/tclsh
tclsh_name=tclsh8.6
tclver=8.6
tclloc=$TERMUX_PREFIX
tcldll=libtcl8.6.so

vi_cv_path_ruby=$TERMUX_PREFIX/bin/ruby
libruby_soname=libruby.so
rubyhdrdir=$TERMUX_PREFIX/include/ruby-2.5.0/
rubyversion=25
librubyarg=-lruby
librubya=-libruby-static.a
rubylibdir=$TERMUX_PREFIX/lib

ac_cv_path_vi_cv_path_perl=$TERMUX_PREFIX/bin/perl
vi_cv_perllib=$TERMUX_PREFIX/lib/perl5/5.26.2
--enable-python3interp=dynamic
--with-python3-config-dir=$TERMUX_PREFIX/lib/python3.6/config-3.6m/
--enable-luainterp=dynamic
--with-lua-prefix=$TERMUX_PREFIX
--enable-perlinterp=dynamic
--enable-rubyinterp=dynamic
--with-ruby-command=$TERMUX_PREFIX/bin/ruby
--enable-tclinterp=dynamic
--with-tclsh=$TERMUX_PREFIX/bin/tclsh8.6
--enable-fail-if-missing
"
TERMUX_PKG_DESCRIPTION+=" - with python, ruby, lua, perl and tcl support"
# Remove share/vim/vim81 which is in vim-runtime built as a subpackage of vim:
TERMUX_PKG_RM_AFTER_INSTALL+=" share/vim/vim81"
termux_step_pre_configure() {
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python3.6m -I${TERMUX_PREFIX}/include/ruby-2.5.0/ -I${TERMUX_PREFIX}/include/ruby-2.5.0/${TERMUX_ARCH}-linux-androideabi -I${TERMUX_PREFIX}/include/ruby-2.5.0/${TERMUX_ARCH}-linux-android -I${TERMUX_PREFIX}/include/perl -I${TERMUX_PREFIX}/lib/perl5/5.26.2/ -I${TERMUX_PREFIX}/lib/perl5/5.26.2/${TERMUX_ARCH}-android/CORE"
	CFLAGS+=" -I${TERMUX_PREFIX}/include/python3.6m -I${TERMUX_PREFIX}/include/ruby-2.5.0/ -I${TERMUX_PREFIX}/include/ruby-2.5.0/${TERMUX_ARCH}-linux-androideabi -I${TERMUX_PREFIX}/include/ruby-2.5.0/${TERMUX_ARCH}-linux-android -I${TERMUX_PREFIX}/include/perl -I${TERMUX_PREFIX}/lib/perl5/5.26.2 -I${TERMUX_PREFIX}/lib/perl5/5.26.2/${TERMUX_ARCH}-android/CORE"
	#LDFLAGS+="-lperl -lm -ldl -Wl -E -L${TERMUX_PREFIX}/lib/perl5/5.26.2/${TERMUX_ARCH}-android/CORE"
	# Remove eventually existing symlinks from previous builds so that they get re-created
	for b in rview rvim ex view vimdiff; do rm -f $TERMUX_PREFIX/bin/$b; done
	rm -f $TERMUX_PREFIX/share/man/man1/view.1

	# Regenerate the configure script so that patches to configure.ac are respected
	cd src
	autoconf
	cd ..
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/vimrc $TERMUX_PREFIX/share/vim/vimrc

	# Remove most tutor files:
	cp $TERMUX_PREFIX/share/vim/vim81/tutor/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PKG_TMPDIR/
	rm -f $TERMUX_PREFIX/share/vim/vim81/tutor/*
	cp $TERMUX_PKG_TMPDIR/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PREFIX/share/vim/vim81/tutor/

	cd $TERMUX_PREFIX/bin
	ln -f -s vim vi
}
