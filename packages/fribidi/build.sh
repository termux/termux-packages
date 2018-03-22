TERMUX_PKG_HOMEPAGE=https://github.com/fribidi/fribidi/
TERMUX_PKG_DESCRIPTION="Implementation of the Unicode Bidirectional Algorithm"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_SHA256=bd6d1b530c4f6066f42461200ed6a31f2db8db208570ea4ccaab2b935e88832b
TERMUX_PKG_SRCURL=https://github.com/fribidi/fribidi/releases/download/v$TERMUX_PKG_VERSION/fribidi-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-docs"
