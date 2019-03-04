TERMUX_PKG_HOMEPAGE=https://github.com/dstosberg/odt2txt
TERMUX_PKG_DESCRIPTION="simple converter from OpenDocument Text to plain text"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_SHA256=23a889109ca9087a719c638758f14cc3b867a5dcf30a6c90bf6a0985073556dd
TERMUX_PKG_SRCURL=https://github.com/dstosberg/odt2txt/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, libzip"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="DESTDIR=$TERMUX_PREFIX MANDIR=$TERMUX_PREFIX/share/man/man1"
