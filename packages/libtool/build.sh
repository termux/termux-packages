TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtool/
TERMUX_PKG_DESCRIPTION="Generic library support script hiding the complexity of using shared libraries behind a consistent, portable interface"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.4.6
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libtool/libtool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e3bd4d5d3d025a36c21dd6af7ea818a2afcd4dfc1ea5a17b39d7854bcd0c06e3
TERMUX_PKG_DEPENDS="bash,grep,sed,libltdl"
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_CONFLICTS="libtool-dev"
TERMUX_PKG_REPLACES="libtool-dev"

termux_step_post_make_install() {
	perl -p -i -e "s|\"/bin/|\"$TERMUX_PREFIX/bin/|" $TERMUX_PREFIX/bin/{libtool,libtoolize}
}
