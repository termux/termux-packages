TERMUX_PKG_HOMEPAGE="https://github.com/Genivia/ugrep"
TERMUX_PKG_DESCRIPTION="A faster, user-friendly and compatible grep replacement"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.12.4"
TERMUX_PKG_SRCURL="https://github.com/Genivia/ugrep/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a36d20492026a36b8436c91f65189c7ea98b4b599c4704f170159c1d9676dc3b
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
