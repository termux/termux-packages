TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtool/
TERMUX_PKG_DESCRIPTION="Generic library support script hiding the complexity of using shared libraries behind a consistent, portable interface"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.3"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libtool/libtool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9322bd8f6bc848fda3e385899dd1934957169652acef716d19d19d24053abb95
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash, grep, sed, libltdl"
TERMUX_PKG_CONFLICTS="libtool-dev, libtool-static"
TERMUX_PKG_REPLACES="libtool-dev, libtool-static"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_GROUPS="base-devel"

termux_step_post_make_install() {
	perl -p -i -e "s|\"/bin/|\"$TERMUX_PREFIX/bin/|" $TERMUX_PREFIX/bin/{libtool,libtoolize}
}
