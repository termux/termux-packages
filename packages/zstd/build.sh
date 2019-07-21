TERMUX_PKG_HOMEPAGE=https://github.com/facebook/zstd
TERMUX_PKG_DESCRIPTION="Zstandard compression."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=https://github.com/facebook/zstd/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f91ea3397e6cc65d398e1bc0713cf2f0b0de2fb85ea9dabb1eb3e8f1b22f8d6f
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="liblzma, zlib"
