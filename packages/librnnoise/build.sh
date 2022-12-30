TERMUX_PKG_HOMEPAGE=https://jmvalin.ca/demo/rnnoise/
TERMUX_PKG_DESCRIPTION="RNN-based noise suppression"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=7f449bf8bd3b933891d12c30112268c4090e4d59
TERMUX_PKG_VERSION=2021.03.12
TERMUX_PKG_SRCURL=git+https://gitlab.xiph.org/xiph/rnnoise
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-examples
--disable-doc
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

termux_step_pre_configure() {
	autoreconf -fi
}
