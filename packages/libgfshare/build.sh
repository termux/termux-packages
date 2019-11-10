TERMUX_PKG_HOMEPAGE=http://www.digital-scurf.org/software/libgfshare
TERMUX_PKG_DESCRIPTION="Utilities for multi-way secret-sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=http://www.digital-scurf.org/files/libgfshare/libgfshare-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=86f602860133c828356b7cf7b8c319ba9b27adf70a624fe32275ba1ed268331f
TERMUX_PKG_BREAKS="libgfshare-dev"
TERMUX_PKG_REPLACES="libgfshare-dev"

termux_step_post_configure() {
	gcc -DHAVE_CONFIG_H \
		-I. \
		-I"$TERMUX_PKG_SRCDIR" \
		-I"$TERMUX_PKG_SRCDIR"/include \
		"$TERMUX_PKG_SRCDIR"/src/gfshare_maketable.c \
		-o gfshare_maketable
	touch -d "next hour" gfshare_maketable
}
