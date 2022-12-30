TERMUX_PKG_HOMEPAGE=https://github.com/tome2/tome2
TERMUX_PKG_DESCRIPTION="An open world roguelike adventure set in middle earth"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=git+https://github.com/tome2/tome2
TERMUX_PKG_VERSION=2022.02.24
TERMUX_PKG_REVISION=1
TERMUX_PKG_GIT_BRANCH=master
_COMMIT=d25bdae09bffea46ac54e51b99b2c166d9be7db8
TERMUX_PKG_DEPENDS="libc++, ncurses, boost"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DSYSTEM_INSTALL=YES"

termux_step_post_get_source() {
	git fetch --unshallow || true
	git checkout $_COMMIT

	local version="$(git rev-parse HEAD)"
	if [ "$version" != "$_COMMIT" ]; then
		echo -n "ERROR: Failed to check out the specified version; \"$_COMMIT\""
		echo " differs from the current HEAD: \"$version\""
		return 1
	fi
}

termux_step_install_license() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/LICENSE \
		$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE
}
