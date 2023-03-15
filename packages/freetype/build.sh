TERMUX_PKG_HOMEPAGE=https://www.freetype.org
TERMUX_PKG_DESCRIPTION="Software font engine capable of producing high-quality output"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.13.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/freetype/freetype-${TERMUX_PKG_VERSION}.tar.xz
#TERMUX_PKG_SRCURL=https://download.savannah.nongnu.org/releases/freetype/freetype-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5ee23abd047636c24b2d43c6625dcafc66661d1aca64dec9e0d05df29592624c
TERMUX_PKG_DEPENDS="brotli, libbz2, libpng, zlib, harfbuzz"
TERMUX_PKG_ANTI_BUILD_DEPENDS="harfbuzz"
TERMUX_PKG_BREAKS="freetype-dev"
TERMUX_PKG_REPLACES="freetype-dev"

termux_step_override_config_scripts() {
	if ${_BUILD_FREETYPE_WITHOUT_HARFBUZZ:=false}; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-harfbuzz=no"
	else
		# Build harfbuzz
		_BUILD_FREETYPE_WITHOUT_HARFBUZZ=true TERMUX_BUILD_IGNORE_LOCK=true $TERMUX_SCRIPTDIR/build-package.sh $(test "$TERMUX_INSTALL_DEPS" = true && echo -I || echo -s) $(test "${TERMUX_FORCE_BUILD_DEPENDENCIES}" = "true" && echo "-F" || true) packages/harfbuzz
		termux_step_setup_build_folders
	fi
}

# not install these files anymore so install them manually.
termux_step_post_make_install() {
	install -Dm700 freetype-config $TERMUX_PREFIX/bin/freetype-config
	install -Dm600 ../src/docs/freetype-config.1 $TERMUX_PREFIX/share/man/man1/freetype-config.1

	if $_BUILD_FREETYPE_WITHOUT_HARFBUZZ; then
		# Skip packaging
		exit 0
	fi
}
