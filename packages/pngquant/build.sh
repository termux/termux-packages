TERMUX_PKG_HOMEPAGE=https://pngquant.org
TERMUX_PKG_DESCRIPTION="PNG image optimising utility"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.12.5
TERMUX_PKG_SHA256=(9d2c5197b21c42931623fb3e6064b91c133bfb52c84428ee1bf9b84712c9b83c
                   605d6f21df568d6dbdf206cfed1260bb9a26a4a0909d13841ebbb30b5dd58c40)
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
