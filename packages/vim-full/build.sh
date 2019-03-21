TERMUX_PKG_HOMEPAGE=https://www.vim.org
TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_LICENSE="VIM License"
# Perl support for some reason can't be properly configured as dynamic
TERMUX_PKG_DEPENDS="ncurses, vim-runtime, perl"
TERMUX_PKG_RECOMMENDS="diffutils"
TERMUX_PKG_SUGGESTS="python, ruby, tcl, liblua"
# vim should only be updated every 50 releases on multiples of 50.
# Update vim, vim-python and vim-full to the same version in one PR.
TERMUX_PKG_VERSION=8.1.1000
TERMUX_PKG_SHA256=b5a2307d7c8382ed68e9c5d058b2db91d9b4873c5a3ccfcdcba3208a86d321e9
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
RUBY_VERSION="$(ls $TERMUX_PREFIX/lib/ruby | grep -E '[0-9]')"
# First, the dots are removed, then only the 2 most significant parts of the version number are kept
# For example, ruby "2.6.0" would turn into "26"
# Don't ask me why this weird version format is used, it's just what the configure script expects.
RUBY_VERSION_NODOT="$( echo $RUBY_VERSION | grep -Eo '[0-9]' | head -n 2 | awk '{key=$0; getline; print key "" $0;}')"

PERL_VERSION="$(ls $TERMUX_PREFIX/lib/perl5/ | grep -E '[0-9]')"
PYTHON_VERSION="$(ls $TERMUX_PREFIX/lib/ | grep -Eo 'python*3.[0-9]' | head -1 | grep -Eo '3.[0-9]*')"
TCL_VERSION="$(ls $TERMUX_PREFIX/bin/ | grep -Eo 'tclsh.+' | grep -o '[0-9|\.]*' )"


TERMUX_PKG_CONFLICTS="vim, vim-python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
vi_cv_path_python3_pfx=$TERMUX_PREFIX
vi_cv_var_python3_version=${PYTHON_VERSION}

vi_cv_path_tcl=$TERMUX_PREFIX/bin/tclsh
tclsh_name=tclsh${TCL_VERSION}
tclver=${TCL_VERSION}
tclloc=$TERMUX_PREFIX
tcldll=libtcl${TCL_VERSION}.so

vi_cv_path_ruby=$TERMUX_PREFIX/bin/ruby
libruby_soname=libruby.so
rubyhdrdir=$TERMUX_PREFIX/include/ruby-${RUBY_VERSION}/
rubyversion=${RUBY_VERSION_NODOT}
librubyarg=-lruby
librubya=-libruby-static.a
rubylibdir=$TERMUX_PREFIX/lib

ac_cv_path_vi_cv_path_perl=$TERMUX_PREFIX/bin/perl
vi_cv_perllib=$TERMUX_PREFIX/lib/perl5/${PERL_VERSION}
--enable-python3interp=dynamic
--with-python3-config-dir=$TERMUX_PREFIX/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}m/
--enable-luainterp=dynamic
--with-lua-prefix=$TERMUX_PREFIX
--enable-perlinterp=dynamic
--enable-rubyinterp=dynamic
--with-ruby-command=$TERMUX_PREFIX/bin/ruby
--enable-tclinterp=dynamic
--with-tclsh=$TERMUX_PREFIX/bin/tclsh${TCL_VERSION}
--enable-fail-if-missing
"
TERMUX_PKG_DESCRIPTION+=" - with python, ruby, lua, perl and tcl support"
# Remove share/vim/vim81 which is in vim-runtime built as a subpackage of vim:
TERMUX_PKG_RM_AFTER_INSTALL+=" share/vim/vim81"
termux_step_pre_configure() {
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${PYTHON_VERSION}m -I${TERMUX_PREFIX}/include/ruby-${RUBY_VERSION}/ -I${TERMUX_PREFIX}/include/ruby-${RUBY_VERSION}/${TERMUX_ARCH}-linux-androideabi -I${TERMUX_PREFIX}/include/ruby-${RUBY_VERSION}/${TERMUX_ARCH}-linux-android -I${TERMUX_PREFIX}/include/perl -I${TERMUX_PREFIX}/lib/perl5/${PERL_VERSION}/ -I${TERMUX_PREFIX}/lib/perl5/${PERL_VERSION}/${TERMUX_ARCH}-android/CORE"
	CFLAGS+=" -I${TERMUX_PREFIX}/include/python${PYTHON_VERSION}m -I${TERMUX_PREFIX}/include/ruby-${RUBY_VERSION}/ -I${TERMUX_PREFIX}/include/ruby-${RUBY_VERSION}/${TERMUX_ARCH}-linux-androideabi -I${TERMUX_PREFIX}/include/ruby-${RUBY_VERSION}/${TERMUX_ARCH}-linux-android -I${TERMUX_PREFIX}/include/perl -I${TERMUX_PREFIX}/lib/perl5/${PERL_VERSION} -I${TERMUX_PREFIX}/lib/perl5/${PERL_VERSION}/${TERMUX_ARCH}-android/CORE"
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
