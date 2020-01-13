TERMUX_PKG_HOMEPAGE=https://pngquant.org
TERMUX_PKG_DESCRIPTION="PNG image optimising utility"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.12.6
# If both archives are .tar.gz then they overwrite eachother since they are the same version and hence the same name.
# Work around this by using .zip for one of them...
TERMUX_PKG_SRCURL=(https://github.com/pornel/pngquant/archive/$TERMUX_PKG_VERSION.tar.gz
		   https://github.com/ImageOptim/libimagequant/archive/$TERMUX_PKG_VERSION.zip)
TERMUX_PKG_SHA256=(f1c9608668100fa2dd07b3158679b75c33a6854b044b21442d6762d52ed10718
                   80bf900e8ee8e2e3b6da974c873a63abb8e0847f35d84ba12da2e5c604dc5168)
TERMUX_PKG_DEPENDS="libpng, littlecms, zlib"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-sse"

termux_step_post_extract_package() {
	mv $TERMUX_PKG_SRCDIR/libimagequant-$TERMUX_PKG_VERSION/* $TERMUX_PKG_SRCDIR/lib/
}
