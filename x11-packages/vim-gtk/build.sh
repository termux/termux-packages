TERMUX_PKG_HOMEPAGE=https://www.vim.org
TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_LICENSE="VIM License"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_BUILD_DEPENDS="libluajit, perl, python, ruby, tcl"
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libcanberra, libice, libiconv, libsm, libx11, libxt, ncurses, pango"
TERMUX_PKG_SUGGESTS="libluajit, perl, python, ruby, tcl"
TERMUX_PKG_RECOMMENDS="diffutils, xxd"
TERMUX_PKG_CONFLICTS="vim"
TERMUX_PKG_BREAKS="vim-python"
TERMUX_PKG_REPLACES="vim-python"
TERMUX_PKG_PROVIDES="vim-python"
TERMUX_PKG_VERSION="9.1.1750"
TERMUX_PKG_SRCURL="https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fc13049b69db1871da3db8d74a0c5e032d0388f7d0669a83f9ead1fbd8b5f756
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="share/vim/vimrc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_tgetent=zero
vim_cv_toupper_broken=no
vim_cv_tty_group=world
ac_cv_small_wchar_t=no
--with-features=huge
--enable-netbeans=no
--with-tlib=ncursesw
--enable-multibyte
--with-compiledby=Termux
--enable-python3interp=dynamic
--with-python3-config-dir=$TERMUX_PYTHON_HOME/config-${TERMUX_PYTHON_VERSION}/
vi_cv_path_python3_pfx=$TERMUX_PREFIX
vi_cv_path_python3_include=${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}
vi_cv_path_python3_platinclude=${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}
vi_cv_var_python3_abiflags=
vi_cv_var_python3_version=${TERMUX_PYTHON_VERSION}
--enable-luainterp=dynamic
--with-lua-prefix=$TERMUX_PREFIX
--with-luajit
--enable-perlinterp=dynamic
--with-xsubpp=$TERMUX_PREFIX/bin/xsubpp
--enable-rubyinterp=dynamic
--enable-tclinterp=dynamic
--enable-gui=gtk3
--with-x
"

# Avoid overlap with the `xxd` subpackage of `vim` by removing it from vim-gtk
TERMUX_PKG_RM_AFTER_INSTALL="
bin/xxd
share/man/man1/xxd.1
share/vim/vim91/spell/en.ascii*
share/vim/vim91/print
share/vim/vim91/tools
"

# Vim releases every commit as a new patch release.
# To avoid auto update spam, we only update Vim every 50th patch.
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d\d[05]0'

termux_pkg_auto_update() {
	# This auto_update function is shared by `vim` and `vim-gtk`
	# If you make changes to one of them,
	# remember to apply that change to the other as well.
	local release
	release="$(git ls-remote --tags https://github.com/vim/vim.git \
	| grep -oP "refs/tags/v\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
	| sort -V \
	| tail -n1)"

	if [[ "${release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${release}"
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"

	make distclean

	# Remove eventually existing symlinks from previous builds so that they get re-created.
	local -a VIM_BINARIES=('eview' 'evim' 'ex' 'rview' 'rvim' 'view' 'vimdiff')
	local -a VIM_GTK_BINARIES=('gview' 'gvim' 'gvimdiff' 'rgview' 'rgvim')
	for sym in "${VIM_BINARIES[@]}" "${VIM_GTK_BINARIES[@]}"; do
		rm -f "${TERMUX_PREFIX}/bin/${sym}"
		rm -f "$TERMUX_PREFIX/share/man/man1/${sym}.1"*
	done

	# Vim doesn't support cross-compilation for Perl, Ruby and Tcl
	# out of the box, so we need to patch the configure script to make it work.
	local perl_version ruby_major_version tcl_major_version
	perl_version="$(. "$TERMUX_SCRIPTDIR/packages/perl/build.sh"; echo "${TERMUX_PKG_VERSION[0]}")"
	ruby_major_version="$(. "$TERMUX_SCRIPTDIR/packages/ruby/build.sh"; echo "${TERMUX_PKG_VERSION%\.*}")"
	tcl_major_version="$(. "$TERMUX_SCRIPTDIR/packages/tcl/build.sh"; echo "${TERMUX_PKG_VERSION%\.*}")"

	patch="$TERMUX_PKG_BUILDER_DIR/configure-perl-ruby-tcl-cross-compiling.diff"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && sed \
		-e "s%\@PERL_VERSION\@%${perl_version}%g" \
		-e "s%\@RUBY_MAJOR_VERSION\@%${ruby_major_version}%g" \
		-e "s%\@TCL_MAJOR_VERSION\@%${tcl_major_version}%g" \
		-e "s%\@PERL_PLATFORM\@%${TERMUX_ARCH}-android%g" \
		-e "s%\@RUBY_PLATFORM\@%${TERMUX_HOST_PLATFORM}%g" \
		-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$patch" | patch --silent -p1
}

termux_step_post_make_install() {
	sed -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" "$TERMUX_PKG_BUILDER_DIR/vimrc" \
		> "$TERMUX_PREFIX/share/vim/vimrc"

	### Remove most tutor files:
	# Make a directory to temporarily hold the ones we want to keep
	mkdir -p "$TERMUX_PKG_TMPDIR/vim-tutor"
	# Copy what we want to keep into $TERMUX_PKG_TMPDIR/vim-tutor
	cp -r   "$TERMUX_PREFIX/share/vim/vim91/tutor/en/" \
			"$TERMUX_PREFIX/share/vim/vim91/tutor/tutor.vim" \
			"$TERMUX_PREFIX/share/vim/vim91/tutor/tutor.tutor"{,.json} \
			"$TERMUX_PREFIX/share/vim/vim91/tutor/tutor"{1,2} \
			"$TERMUX_PKG_TMPDIR/vim-tutor"
	# Remove all the tutor files
	rm -rf "$TERMUX_PREFIX/share/vim/vim91/tutor"/*
	# Copy back what we saved earlier
	cp -r "$TERMUX_PKG_TMPDIR"/vim-tutor/* "$TERMUX_PREFIX/share/vim/vim91/tutor/"
	mkdir -p "$TERMUX_PREFIX/libexec/vim"
	mv "${TERMUX_PREFIX}"/bin/{ex,view,vim{,diff,tutor}} "${TERMUX_PREFIX}"/libexec/vim
}
