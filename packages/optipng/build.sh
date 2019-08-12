TERMUX_PKG_HOMEPAGE=http://optipng.sourceforge.net/
TERMUX_PKG_DESCRIPTION="PNG optimizer that recompresses image files to a smaller size, without losing any information"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_VERSION=0.7.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=4f32f233cef870b3f95d3ad6428bfe4224ef34908f1b42b0badf858216654452
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-${TERMUX_PKG_VERSION}/optipng-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libpng, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-zlib --with-system-libpng --mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LD=$CC
}
