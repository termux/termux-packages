TERMUX_PKG_HOMEPAGE=https://github.com/eafer/rdrview
TERMUX_PKG_DESCRIPTION="Command line tool to extract the main content from a webpage"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=9bde19f9e53562790b363bb2e3b15707c8c67676
TERMUX_PKG_VERSION=2021.09.12
TERMUX_PKG_SRCURL=https://github.com/eafer/rdrview.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libcurl, libiconv, libseccomp, libxml2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT
}

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
