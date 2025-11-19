TERMUX_PKG_HOMEPAGE=https://optipng.sourceforge.net/
TERMUX_PKG_DESCRIPTION="PNG optimizer that recompresses image files to a smaller size, without losing any information"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.9.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-${TERMUX_PKG_VERSION}/optipng-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c2579be58c2c66dae9d63154edcb3d427fef64cb00ec0aff079c9d156ec46f29
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpng, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-zlib --with-system-libpng --mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LD=$CC
}
