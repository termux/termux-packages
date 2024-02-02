TERMUX_PKG_HOMEPAGE=https://optipng.sourceforge.net/
TERMUX_PKG_DESCRIPTION="PNG optimizer that recompresses image files to a smaller size, without losing any information"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.8"
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-${TERMUX_PKG_VERSION}/optipng-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=25a3bd68481f21502ccaa0f4c13f84dcf6b20338e4c4e8c51f2cefbd8513398c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpng, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-zlib --with-system-libpng --mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LD=$CC
}
