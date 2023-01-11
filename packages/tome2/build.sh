TERMUX_PKG_HOMEPAGE=https://github.com/tome2/tome2
TERMUX_PKG_DESCRIPTION="An open world roguelike adventure set in middle earth"
TERMUX_PKG_LICENSE="non-free"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=1e26568b084104edd2a696e86118a3e71c78d61e
TERMUX_PKG_VERSION=2022.12.27
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/tome2/tome2
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="boost, libc++, libx11, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DSYSTEM_INSTALL=YES"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_install_license() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/LICENSE \
		$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE
}
