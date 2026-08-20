TERMUX_PKG_HOMEPAGE=https://www.nerdfonts.com/
TERMUX_PKG_DESCRIPTION="Roboto Mono patched with Nerd Fonts icons/glyphs (Font Awesome, Devicons, Octicons, Powerline, etc)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/ryanoasis/nerd-fonts/releases/download/v${TERMUX_PKG_VERSION}/RobotoMono.zip
TERMUX_PKG_SHA256=31672eccf247e70e220466e65ee9dd9ff78bf1af264fdb9631d5702ea60b44fa
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
	## Only keep the plain (non-Mono, non-Propo) Regular/Bold/Italic/BoldItalic
	## styles to keep the package size reasonable.
	mkdir -p "$TERMUX_PREFIX/share/fonts/TTF"
	cp RobotoMonoNerdFont-Regular.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp RobotoMonoNerdFont-Bold.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp RobotoMonoNerdFont-Italic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp RobotoMonoNerdFont-BoldItalic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
}
