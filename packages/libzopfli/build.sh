TERMUX_PKG_HOMEPAGE=https://github.com/google/zopfli
TERMUX_PKG_DESCRIPTION="New zlib compatible compressor library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_SRCURL=https://github.com/google/zopfli/archive/zopfli-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e955a7739f71af37ef3349c4fa141c648e8775bceb2195be07e86f8e638814bd
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libzopfli-dev"
TERMUX_PKG_REPLACES="libzopfli-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	make zopflipng
	cp zopfli zopflipng $TERMUX_PREFIX/bin/

	mkdir -p $TERMUX_PREFIX/include/zopfli/
	cp $TERMUX_PKG_SRCDIR/src/zopfli/*h $TERMUX_PREFIX/include/zopfli/
}
