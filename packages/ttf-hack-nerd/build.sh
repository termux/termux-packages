TERMUX_PKG_HOMEPAGE=https://www.nerdfonts.com/
TERMUX_PKG_DESCRIPTION="Hack patched with Nerd Fonts icons/glyphs (Font Awesome, Devicons, Octicons, Powerline, etc)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/ryanoasis/nerd-fonts/releases/download/v${TERMUX_PKG_VERSION}/Hack.zip
TERMUX_PKG_SHA256=24a54aa41ff8ca5829409bfeb1bc2883b9fcafbf79f8d4b7674898550cb5e3b3
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
	cp HackNerdFont-Regular.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp HackNerdFont-Bold.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp HackNerdFont-Italic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp HackNerdFont-BoldItalic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
}
