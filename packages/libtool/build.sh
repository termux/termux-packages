TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtool/
TERMUX_PKG_DESCRIPTION="Generic library support script hiding the complexity of using shared libraries behind a consistent, portable interface"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.7
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libtool/libtool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04e96c2404ea70c590c546eba4202a4e12722c640016c12b9b2f1ce3d481e9a8
TERMUX_PKG_DEPENDS="bash, grep, sed, libltdl"
TERMUX_PKG_CONFLICTS="libtool-dev, libtool-static"
TERMUX_PKG_REPLACES="libtool-dev, libtool-static"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_GROUPS="base-devel"

termux_step_post_make_install() {
	perl -p -i -e "s|\"/bin/|\"$TERMUX_PREFIX/bin/|" $TERMUX_PREFIX/bin/{libtool,libtoolize}
}
