TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libtool/
TERMUX_PKG_DESCRIPTION="Generic library support script hiding the complexity of using shared libraries behind a consistent, portable interface"
TERMUX_PKG_DEPENDS="bash,grep,sed"
TERMUX_PKG_VERSION=2.4.6
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://ftpmirror.gnu.org/libtool/libtool-${TERMUX_PKG_VERSION}.tar.gz

termux_step_post_make_install () {
	perl -p -i -e "s|\"/bin/|\"$TERMUX_PREFIX/bin/|" $TERMUX_PREFIX/bin/{libtool,libtoolize}
}
