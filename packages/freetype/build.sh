TERMUX_PKG_HOMEPAGE=https://www.freetype.org
TERMUX_PKG_DESCRIPTION="Software font engine capable of producing high-quality output"
TERMUX_PKG_VERSION=2.9.1
TERMUX_PKG_SHA256=db8d87ea720ea9d5edc5388fc7a0497bb11ba9fe972245e0f7f4c7e8b1e1e84d
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/freetype/freetype2/${TERMUX_PKG_VERSION}/freetype-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libbz2, libpng"
TERMUX_PKG_REVISION=1
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/freetype-config share/man/man1/freetype-config.1"
# Use with-harfbuzz=no to avoid circular dependency between freetype and harfbuzz:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-harfbuzz=no"
# not install these files anymore so install them manually.
termux_step_post_make_install () {
	cp freetype-config $TERMUX_PREFIX/bin
	cp ../src/docs/freetype-config.1 $TERMUX_PREFIX/share/man/man1/
}

