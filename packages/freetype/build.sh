TERMUX_PKG_HOMEPAGE=https://www.freetype.org
TERMUX_PKG_DESCRIPTION="Software font engine capable of producing high-quality output"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.10.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.savannah.gnu.org/releases/freetype/freetype-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=c22244bc766b2d8152f22db7370965431dcb1e408260428208c24984f78e6659
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

