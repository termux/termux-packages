TERMUX_PKG_HOMEPAGE=https://github.com/flann-lib/flann
TERMUX_PKG_DESCRIPTION="A library for performing fast approximate nearest neighbor searches in high dimensional spaces"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=f9caaf609d8b8cb2b7104a85cf59eb92c275a25d
TERMUX_PKG_VERSION="2022.10.27"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/flann-lib/flann
TERMUX_PKG_SHA256=ed889b301be373af6575d655e03e327039aa2923f70cb619a4d57fd931682630
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

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
}
