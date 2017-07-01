TERMUX_PKG_HOMEPAGE=http://optipng.sourceforge.net/
TERMUX_PKG_DESCRIPTION="PNG optimizer that recompresses image files to a smaller size, without losing any information"
TERMUX_PKG_DEPENDS="libpng"
TERMUX_PKG_VERSION=0.7.6
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-${TERMUX_PKG_VERSION}/optipng-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4870631fcbd3825605f00a168b8debf44ea1cda8ef98a73e5411eee97199be80
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-zlib --with-system-libpng --mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	LD=$CC
}
