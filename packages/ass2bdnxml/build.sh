TERMUX_PKG_HOMEPAGE=https://ps-auxw.de/avs2bdnxml/
TERMUX_PKG_DESCRIPTION="AVS to BluRay SUP/PGS and BDN XML"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=42a5572c631bbb4dcf9b43d07179de8c5607d47c
TERMUX_PKG_VERSION=2019.02.06
TERMUX_PKG_SRCURL=https://github.com/hguandl/ass2bdnxml.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libpng"

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
	LDFLAGS+=" -lm"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ass2bdnxml
}
