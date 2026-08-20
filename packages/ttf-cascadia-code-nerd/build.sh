TERMUX_PKG_HOMEPAGE=https://www.nerdfonts.com/
TERMUX_PKG_DESCRIPTION="Cascadia Code patched with Nerd Fonts icons/glyphs (Font Awesome, Devicons, Octicons, Powerline, etc)"
TERMUX_PKG_LICENSE="OFL-1.1"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/ryanoasis/nerd-fonts/releases/download/v${TERMUX_PKG_VERSION}/CascadiaCode.zip
TERMUX_PKG_SHA256=34230d1534c70976bc508abfa9a3b0ec3faf12881e83b85eb5a0cbe225682256
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
	## NOTE: upstream file name is "Caskaydia Cove" (the Nerd Fonts fork name
	## for Cascadia Code), only keep Regular/Bold/Italic/BoldItalic styles to
	## keep the package size reasonable.
	mkdir -p "$TERMUX_PREFIX/share/fonts/TTF"
	cp CaskaydiaCoveNerdFont-Regular.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp CaskaydiaCoveNerdFont-Bold.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp CaskaydiaCoveNerdFont-Italic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp CaskaydiaCoveNerdFont-BoldItalic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
}
