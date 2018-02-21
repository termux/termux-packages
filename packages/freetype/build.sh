TERMUX_PKG_HOMEPAGE=https://www.freetype.org
TERMUX_PKG_DESCRIPTION="Software font engine capable of producing high-quality output"
TERMUX_PKG_VERSION=2.9
TERMUX_PKG_SHA256=e6ffba3c8cef93f557d1f767d7bc3dee860ac7a3aaff588a521e081bc36f4c8a
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/freetype/freetype2/${TERMUX_PKG_VERSION}/freetype-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libbz2, libpng"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/freetype-config share/man/man1/freetype-config.1"
# Use with-harfbuzz=no to avoid circular dependency between freetype and harfbuzz:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-harfbuzz=no"
