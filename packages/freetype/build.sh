TERMUX_PKG_HOMEPAGE=http://www.freetype.org/
TERMUX_PKG_DESCRIPTION="Software font engine capable of producing high-quality output"
TERMUX_PKG_VERSION=2.6.3
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/freetype/freetype2/${TERMUX_PKG_VERSION}/freetype-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libbz2, libpng"
TERMUX_PKG_RM_AFTER_INSTALL="bin/freetype-config share/man/man1/freetype-config.1"
# Use with-harfbuzz=no to avoid circular dependency between freetype and harfbuzz:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-harfbuzz=no"
