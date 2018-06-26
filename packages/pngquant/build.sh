TERMUX_PKG_HOMEPAGE=https://pngquant.org
TERMUX_PKG_DESCRIPTION="PNG image optimising utility"
TERMUX_PKG_VERSION=2.12.1
TERMUX_PKG_SHA256=(352ff60420fd5ab7a94f548be6f87dbdfa15eb28e3cc8f61c089f4e0be7ee1a0
		   c0f6ddfb1ed214a520b18f6fff16fe09f39d427caf9679b05657e32dfdc2cb27)
# If both archives are .tar.gz then they overwrite eachother since they are the same version and hence the same name.
# Work around this by using .zip for one of them...
TERMUX_PKG_SRCURL=(https://github.com/pornel/pngquant/archive/$TERMUX_PKG_VERSION.tar.gz
		   https://github.com/ImageOptim/libimagequant/archive/$TERMUX_PKG_VERSION.zip)
TERMUX_PKG_DEPENDS="libpng, littlecms"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-sse"

termux_step_post_extract_package () {
	mv $TERMUX_PKG_SRCDIR/libimagequant-$TERMUX_PKG_VERSION/* $TERMUX_PKG_SRCDIR/lib/
}
