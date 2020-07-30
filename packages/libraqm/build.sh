TERMUX_PKG_HOMEPAGE=https://github.com/HOST-Oman/libraqm
TERMUX_PKG_DESCRIPTION="Raqm is a small library that encapsulates the logic for complex text layout and provides a convenient API."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/HOST-Oman/libraqm/releases/download/v$TERMUX_PKG_VERSION/raqm-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e28575ecdd4e8a1d277d9be8268bb663ce1e476aaf55eb0456787821ddf0f941
TERMUX_PKG_DEPENDS="freetype, harfbuzz, fribidi"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk-doc"
