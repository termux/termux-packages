TERMUX_PKG_HOMEPAGE=https://www.vim.org
TERMUX_PKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_PKG_LICENSE="VIM License"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libcanberra, libice, libiconv, liblua52, libsm, libx11, libxt, ncurses, pango, python"
TERMUX_PKG_RECOMMENDS="diffutils"
TERMUX_PKG_CONFLICTS="vim, vim-python, vim-runtime"
TERMUX_PKG_VERSION=9.1.0800
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/vim/vim/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3bc15301f35addac9acde1da64da0976dbeafe1264e904c25a3cdc831e347303
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_tgetent=zero
vim_cv_toupper_broken=no
vim_cv_tty_group=world
--with-compiledby='Termux'
--enable-gui=gtk3
--enable-multibyte
--enable-netbeans=no
--with-features=huge
--with-tlib=ncursesw
--with-x
ac_cv_small_wchar_t=no
--enable-cscope
vi_cv_path_python3_pfx=$TERMUX_PREFIX
vi_cv_path_python3_include=${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}
vi_cv_path_python3_platinclude=${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}
vi_cv_var_python3_abiflags=
vi_cv_var_python3_version=${TERMUX_PYTHON_VERSION}
--enable-python3interp
--with-python3-config-dir=$TERMUX_PYTHON_HOME/config-${TERMUX_PYTHON_VERSION}/
ac_cv_path_vi_cv_path_plain_lua=lua5.2
--enable-luainterp
--with-lua-prefix=$TERMUX_PREFIX
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/vim/vim91/spell/en.ascii*
share/vim/vim91/print
share/vim/vim91/tools
"

TERMUX_PKG_CONFFILES="share/vim/vimrc"

# Vim releases every commit as a new patch release.
# To avoid auto update spam, we only update Vim every 50th patch.
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d{2}(5|0)0'

termux_pkg_auto_update() {
	# This auto_update function is shared by `vim`, `vim-python` and `vim-gtk`
	# If you make changes to one of them,
	# remember to apply that change to the other two as well.
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

	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	make distclean

	# Remove eventually existing symlinks from previous builds so that they get re-created.
	for sym in 'eview' 'evim' 'ex' 'gview' 'gvim' 'gvimdiff' 'rgview' 'rgvim' 'rview' 'rvim' 'view' 'vimdiff'; do
		rm -f "$TERMUX_PREFIX/bin/${sym}"
		rm -f "$TERMUX_PREFIX/share/man/man1/${sym}.1"*
	done
}

termux_step_post_make_install() {
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/vimrc" "$TERMUX_PREFIX/share/vim/vimrc"
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "$TERMUX_PREFIX/share/vim/vimrc"
	ln -sfr "$TERMUX_PREFIX/bin/vim" "$TERMUX_PREFIX/bin/vi"
}
