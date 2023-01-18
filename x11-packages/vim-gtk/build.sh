TERMUX_PKG_HOMEPAGE=https://www.vim.org
TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_LICENSE="VIM License"
TERMUX_PKG_MAINTAINER="@termux"

# vim should only be updated every 50 releases on multiples of 50.
# Update all of vim, vim-python and vim-gtk to the same version in one PR.
TERMUX_PKG_VERSION=9.0.1200
TERMUX_PKG_SRCURL=https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=51aceb25a51851b3c570d55edda52134804fde84e42a98ba342ee6091dfa44d3

TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libcanberra, libice, libiconv, liblua52, libsm, libx11, libxt, ncurses, pango, python"
TERMUX_PKG_CONFLICTS="vim, vim-python, vim-runtime"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_small_wchar_t=no
ac_cv_path_vi_cv_path_plain_lua=lua5.2
vi_cv_path_python3_pfx=$TERMUX_PREFIX
vi_cv_var_python3_abiflags=
vi_cv_var_python3_version=${TERMUX_PYTHON_VERSION}
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
--with-python3-config-dir=$TERMUX_PYTHON_HOME/config-${TERMUX_PYTHON_VERSION}/
--with-tlib=ncursesw
--with-x"

TERMUX_PKG_RM_AFTER_INSTALL="
share/vim/vim90/spell/en.ascii*
share/vim/vim90/print
share/vim/vim90/tools
share/applications/mimeinfo.cache
share/icons/hicolor/icon-theme.cache
"

TERMUX_PKG_CONFFILES="share/vim/vimrc"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"

	# Version guard
	local ver_v=$(. $TERMUX_SCRIPTDIR/packages/vim/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	local ver_p=$(. $TERMUX_SCRIPTDIR/packages/vim-python/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	local ver_g=$(. $TERMUX_SCRIPTDIR/x11-packages/vim-gtk/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	if [ "${ver_v}" != "${ver_p}" ] || [ "${ver_p}" != "${ver_g}" ]; then
		termux_error_exit "Version mismatch between vim, vim-python and vim-gtk."
	fi

	make distclean

	# Remove eventually existing symlinks from previous builds so that they get re-created.
	for link in eview evim ex gview gvim gvimdiff rgview rgvim rview rvim view vimdiff; do
		rm -f $TERMUX_PREFIX/bin/$link
		rm -f $TERMUX_PREFIX/share/man/man1/${link}.1*
	done
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/vimrc $TERMUX_PREFIX/share/vim/vimrc
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" $TERMUX_PREFIX/share/vim/vimrc
	ln -sfr $TERMUX_PREFIX/bin/vim $TERMUX_PREFIX/bin/vi
}
