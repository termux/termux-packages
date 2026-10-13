TERMUX_PKG_HOMEPAGE=https://www.nerdfonts.com/
TERMUX_PKG_DESCRIPTION="Symbols-only font containing the Nerd Font icons"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.1"
TERMUX_PKG_SRCURL=https://github.com/ryanoasis/nerd-fonts/releases/download/v$TERMUX_PKG_VERSION/NerdFontsSymbolsOnly.zip
TERMUX_PKG_SHA256=fdca3682534f6f65e1ccb2345b0362ccf67d9b8eca7c8025330946e93e2473bc
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_CONFFILES="
etc/fonts/conf.d/10-nerd-font-symbols.conf
"

# The original "termux_extract_src_archive" always strips the first components
# but the source of font files is directly under the root directory of the zip file
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -q "$file" -d "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	## Install fonts.
	mkdir -p "$TERMUX_PREFIX/share/fonts/TTF"
	cp -f *.ttf "$TERMUX_PREFIX/share/fonts/TTF/"

	## Install config files used by 'fontconfig' package.
	mkdir -p "$TERMUX_PREFIX/etc/fonts/conf.d"
	cp -f *.conf "$TERMUX_PREFIX/etc/fonts/conf.d/"
}
