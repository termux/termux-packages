TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtool/
TERMUX_PKG_DESCRIPTION="Generic library support script hiding the complexity of using shared libraries behind a consistent, portable interface"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libtool/libtool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da8ebb2ce4dcf46b90098daf962cffa68f4b4f62ea60f798d0ef12929ede6adf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash, grep, sed, libltdl"
TERMUX_PKG_CONFLICTS="libtool-dev, libtool-static"
TERMUX_PKG_REPLACES="libtool-dev, libtool-static"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_GROUPS="base-devel"

termux_step_post_make_install() {
	perl -p -i -e \
		"s|\"/usr/bin/|\"$TERMUX_PREFIX/bin/|;s|\"/bin/|\"$TERMUX_PREFIX/bin/|" \
		$TERMUX_PREFIX/bin/{libtool,libtoolize}
}
