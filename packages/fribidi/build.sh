TERMUX_PKG_HOMEPAGE=https://github.com/fribidi/fribidi/
TERMUX_PKG_DESCRIPTION="Implementation of the Unicode Bidirectional Algorithm"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_SHA256=6a64f2a687f5c4f203a46fa659f43dd43d1f8b845df8d723107e8a7e6158e4ce
TERMUX_PKG_SRCURL=https://github.com/fribidi/fribidi/releases/download/v$TERMUX_PKG_VERSION/fribidi-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-docs"
