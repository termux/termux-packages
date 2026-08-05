TERMUX_PKG_HOMEPAGE="https://github.com/Genivia/ugrep"
TERMUX_PKG_DESCRIPTION="A faster, user-friendly and compatible grep replacement"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.8.4"
TERMUX_PKG_SRCURL="https://github.com/Genivia/ugrep/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b16b3503e80890c78a5c845f8c141f239f3904359f1e41900ca566c86e120172
TERMUX_PKG_DEPENDS="brotli, libbz2, libc++, liblz4, liblzma, pcre2, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--includedir=$TERMUX_PREFIX/include
--with-brotli=$TERMUX_PREFIX
--with-pcre2=$TERMUX_PREFIX
--with-zlib=$TERMUX_PREFIX
--with-bzlib=$TERMUX_PREFIX
--with-lzma=$TERMUX_PREFIX
--with-lz4=$TERMUX_PREFIX
--with-zstd=$TERMUX_PREFIX
--disable-static
--disable-sse2
--disable-avx2
"

termux_step_pre_configure() {
	autoreconf -fi
}
