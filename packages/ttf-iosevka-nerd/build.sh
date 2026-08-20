TERMUX_PKG_HOMEPAGE=https://www.nerdfonts.com/
TERMUX_PKG_DESCRIPTION="Iosevka patched with Nerd Fonts icons/glyphs (Font Awesome, Devicons, Octicons, Powerline, etc)"
TERMUX_PKG_LICENSE="OFL-1.1"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/ryanoasis/nerd-fonts/releases/download/v${TERMUX_PKG_VERSION}/Iosevka.zip
TERMUX_PKG_SHA256=a5a218f974c7d3264c0f330c514364aacabf839d8ee92abd05f5c2cd4ad514b5
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
	## Iosevka has a huge number of weights/widths upstream, only keep
	## Regular/Bold/Italic/BoldItalic to keep the package size reasonable.
	mkdir -p "$TERMUX_PREFIX/share/fonts/TTF"
	cp IosevkaNerdFont-Regular.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp IosevkaNerdFont-Bold.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp IosevkaNerdFont-Italic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp IosevkaNerdFont-BoldItalic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
}
