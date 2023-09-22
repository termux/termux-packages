TERMUX_PKG_HOMEPAGE="https://github.com/Genivia/ugrep"
TERMUX_PKG_DESCRIPTION="A faster, user-friendly and compatible grep replacement"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.0"
TERMUX_PKG_SRCURL="https://github.com/Genivia/ugrep/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6692d4b556894d0d4539057b8e0f0c3d6273998cbd2c61e3f17e1bb22b1a475a
TERMUX_PKG_DEPENDS="libbz2, libc++, liblz4, liblzma, pcre2, zlib, zstd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-pcre2=$TERMUX_PREFIX/include
--with-zlib=$TERMUX_PREFIX/include
--with-bzlib=$TERMUX_PREFIX/include
--with-lzma=$TERMUX_PREFIX/include
--with-lz4=$TERMUX_PREFIX/include
--with-zstd=$TERMUX_PREFIX/include
--oldincludedir=$TERMUX_PREFIX/include
"

termux_step_pre_configure() {
	autoreconf -fi
}
