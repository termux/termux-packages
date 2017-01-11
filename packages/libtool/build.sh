TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtool/
TERMUX_PKG_DESCRIPTION="Generic library support script hiding the complexity of using shared libraries behind a consistent, portable interface"
TERMUX_PKG_DEPENDS="bash,grep,sed"
TERMUX_PKG_VERSION=2.4.6
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libtool/libtool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libltdl"
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_CONFLICTS="libtool-dev"
TERMUX_PKG_REPLACES="libtool-dev"

termux_step_post_make_install () {
	perl -p -i -e "s|\"/bin/|\"$TERMUX_PREFIX/bin/|" $TERMUX_PREFIX/bin/{libtool,libtoolize}
	perl -p -i -e "s|${_SPECSFLAG}||g" $TERMUX_PREFIX/bin/{libtool,libtoolize}
}
