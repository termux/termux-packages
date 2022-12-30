TERMUX_PKG_HOMEPAGE=https://github.com/flann-lib/flann
TERMUX_PKG_DESCRIPTION="A library for performing fast approximate nearest neighbor searches in high dimensional spaces"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=f9caaf609d8b8cb2b7104a85cf59eb92c275a25d
TERMUX_PKG_VERSION=2022.10.27
TERMUX_PKG_SRCURL=git+https://github.com/flann-lib/flann
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++, liblz4"
TERMUX_PKG_BUILD_DEPENDS="libhdf5-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_PYTHON_BINDINGS=OFF
-DBUILD_MATLAB_BINDINGS=OFF
-DBUILD_EXAMPLES=OFF
-DBUILD_TESTS=OFF
-DBUILD_DOC=OFF
"

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
