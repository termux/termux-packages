TERMUX_PKG_HOMEPAGE=https://www.vim.org
TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_LICENSE="VIM License"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="libiconv, ncurses, vim-runtime, python"
TERMUX_PKG_RECOMMENDS="diffutils"
# vim should only be updated every 50 releases on multiples of 50.
# Update both vim and vim-python to the same version in one PR.
TERMUX_PKG_VERSION=9.0.1050
TERMUX_PKG_SRCURL="https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5cc8b8f3272d3302384b6f3d52ef6302dbb53587f5d88e2a155767530c1f6c3f
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
--enable-netbeans=no
--with-features=huge
--without-x
--with-tlib=ncursesw
"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/rview
bin/rvim
bin/ex
share/man/man1/evim.1
share/icons
share/vim/vim90/spell/en.ascii*
share/vim/vim90/print
share/vim/vim90/tools
"
TERMUX_PKG_CONFFILES="share/vim/vimrc"

# vim-python:
TERMUX_PKG_CONFLICTS="vim"
_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
vi_cv_path_python3_pfx=$TERMUX_PREFIX
vi_cv_var_python3_abiflags=
vi_cv_var_python3_version=${_PYTHON_VERSION}
--enable-python3interp
--with-python3-config-dir=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/config-${_PYTHON_VERSION}/
"
TERMUX_PKG_DESCRIPTION+=" - with python support"
# Remove share/vim/vim90 which is in vim-runtime built as a subpackage of vim:
TERMUX_PKG_RM_AFTER_INSTALL+=" share/vim/vim90"
termux_step_pre_configure() {
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}"
}

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	make distclean

	# Remove eventually existing symlinks from previous builds so that they get re-created
	for b in rview rvim ex view vimdiff; do rm -f $TERMUX_PREFIX/bin/$b; done
	rm -f $TERMUX_PREFIX/share/man/man1/view.1
}

termux_step_post_make_install() {
	sed -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PKG_BUILDER_DIR/vimrc \
		> $TERMUX_PREFIX/share/vim/vimrc

	# Remove most tutor files:
	cp $TERMUX_PREFIX/share/vim/vim90/tutor/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PKG_TMPDIR/
	rm -f $TERMUX_PREFIX/share/vim/vim90/tutor/*
	cp $TERMUX_PKG_TMPDIR/{tutor,tutor.vim,tutor.utf-8} $TERMUX_PREFIX/share/vim/vim90/tutor/
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/vim 50
			update-alternatives --install \
				$TERMUX_PREFIX/bin/vi vi $TERMUX_PREFIX/bin/vim 20
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/vim
			update-alternatives --remove vi $TERMUX_PREFIX/bin/vim
		fi
	fi
	EOF
}
