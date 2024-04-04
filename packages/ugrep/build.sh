TERMUX_PKG_HOMEPAGE="https://github.com/Genivia/ugrep"
TERMUX_PKG_DESCRIPTION="A faster, user-friendly and compatible grep replacement"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.2"
TERMUX_PKG_SRCURL="https://github.com/Genivia/ugrep/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=24bac5053e994ce55ad1f587cf9333bedfe6e073412b835111969c8f4878131a
TERMUX_PKG_DEPENDS="libbz2, libc++, liblz4, liblzma, pcre2, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-pcre2
--enable-zlib
--enable-bzip2
--enable-lzma
--enable-lz4
--enable-zstd
--includedir=$TERMUX_PREFIX/include
--disable-sse2
--disable-avx2
"

termux_step_pre_configure() {
	autoreconf -fi
}
