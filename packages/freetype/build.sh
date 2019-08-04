TERMUX_PKG_HOMEPAGE=https://www.freetype.org
TERMUX_PKG_DESCRIPTION="Software font engine capable of producing high-quality output"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.10.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=16dbfa488a21fe827dc27eaf708f42f7aa3bb997d745d31a19781628c36ba26f
TERMUX_PKG_SRCURL=https://download.savannah.gnu.org/releases/freetype/freetype-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libbz2, libpng, zlib"
TERMUX_PKG_BREAKS="freetype-dev"
TERMUX_PKG_REPLACES="freetype-dev"
# Use with-harfbuzz=no to avoid circular dependency between freetype and harfbuzz:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-harfbuzz=no"
# not install these files anymore so install them manually.
termux_step_post_make_install() {
	install -Dm700 freetype-config $TERMUX_PREFIX/bin/freetype-config
	install -Dm600 ../src/docs/freetype-config.1 $TERMUX_PREFIX/share/man/man1/freetype-config.1
}

