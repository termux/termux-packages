TERMUX_PKG_HOMEPAGE=https://www.nerdfonts.com/
TERMUX_PKG_DESCRIPTION="Source Code Pro patched with Nerd Fonts icons/glyphs (Font Awesome, Devicons, Octicons, Powerline, etc)"
TERMUX_PKG_LICENSE="OFL-1.1"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/ryanoasis/nerd-fonts/releases/download/v${TERMUX_PKG_VERSION}/SourceCodePro.zip
TERMUX_PKG_SHA256=e8d18dae2086b5f45dc6e20c10c9b35c52d1bfeaf50426cfb54002fb744f0fa0
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

# The release zip is a flat archive of *.ttf files (no subfolders), so the
# default "termux_extract_src_archive" (which expects the upstream project
# layout) is not needed here - a plain unzip is enough.
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -q "$file" -d "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	## Install fonts.
	## NOTE: upstream file name is "Sauce Code Pro" (the Nerd Fonts fork name
	## for Source Code Pro), only keep Regular/Bold/Italic/BoldItalic styles
	## to keep the package size reasonable.
	mkdir -p "$TERMUX_PREFIX/share/fonts/TTF"
	cp SauceCodeProNerdFont-Regular.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp SauceCodeProNerdFont-Bold.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp SauceCodeProNerdFont-Italic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp SauceCodeProNerdFont-BoldItalic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
}
