TERMUX_PKG_HOMEPAGE=https://pngquant.org
TERMUX_PKG_DESCRIPTION="PNG image optimising utility"
TERMUX_PKG_VERSION=2.11.7
TERMUX_PKG_SHA256=(0ca09a1f253b264e5aab8477b7f0e3cde51d9f88ed668b38ae057ced24076bda
		   6b912616cfb60c5ff49f316649e1279bd7a1d797d6ace0bdbb532ebdf778a8bd)
# If both archives are .tar.gz then they overwrite eachother since they are the same version and hence the same name.
# Work around this by using .zip for one of them...
TERMUX_PKG_SRCURL=(https://github.com/pornel/pngquant/archive/$TERMUX_PKG_VERSION.tar.gz
		   https://github.com/ImageOptim/libimagequant/archive/$TERMUX_PKG_VERSION.zip)
TERMUX_PKG_DEPENDS="libpng"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-sse"

termux_step_post_extract_package () {
	mv $TERMUX_PKG_SRCDIR/libimagequant-$TERMUX_PKG_VERSION/* $TERMUX_PKG_SRCDIR/lib/
}
