TERMUX_PKG_HOMEPAGE=https://pngquant.org
TERMUX_PKG_DESCRIPTION="PNG image optimising utility"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.12.3
TERMUX_PKG_SHA256=(507c0cd220326b6ec36097195230a9b5b89b23bcf5ade7c4e7b054d3d86120d7
		   97871b1b36ed8bab61ffb56a61c2f1f675f113dbb0db8f95b5fa03fdf4671365)
# If both archives are .tar.gz then they overwrite eachother since they are the same version and hence the same name.
# Work around this by using .zip for one of them...
TERMUX_PKG_SRCURL=(https://github.com/pornel/pngquant/archive/$TERMUX_PKG_VERSION.tar.gz
		   https://github.com/ImageOptim/libimagequant/archive/$TERMUX_PKG_VERSION.zip)
TERMUX_PKG_DEPENDS="libpng, littlecms, zlib"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-sse"

termux_step_post_extract_package() {
	mv $TERMUX_PKG_SRCDIR/libimagequant-$TERMUX_PKG_VERSION/* $TERMUX_PKG_SRCDIR/lib/
}
