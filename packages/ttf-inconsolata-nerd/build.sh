TERMUX_PKG_HOMEPAGE=https://www.nerdfonts.com/
TERMUX_PKG_DESCRIPTION="Inconsolata patched with Nerd Fonts icons/glyphs (Font Awesome, Devicons, Octicons, Powerline, etc)"
TERMUX_PKG_LICENSE="OFL-1.1"
TERMUX_PKG_LICENSE_FILE="OFL.txt"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/ryanoasis/nerd-fonts/releases/download/v${TERMUX_PKG_VERSION}/Inconsolata.zip
TERMUX_PKG_SHA256=2b10ce776b163467d64b20fc64a2d5b83cd79d596c3acc0ab9cec7adea5c2e8f
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
	## NOTE: upstream Inconsolata Nerd Font only ships Regular and Bold -
	## there is no Italic/BoldItalic .ttf in this release.
	mkdir -p "$TERMUX_PREFIX/share/fonts/TTF"
	cp InconsolataNerdFont-Regular.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp InconsolataNerdFont-Bold.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
}
