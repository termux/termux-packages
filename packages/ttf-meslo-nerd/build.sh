TERMUX_PKG_HOMEPAGE=https://www.nerdfonts.com/
TERMUX_PKG_DESCRIPTION="Meslo (MesloLGS) patched with Nerd Fonts icons/glyphs (Font Awesome, Devicons, Octicons, Powerline, etc), commonly used with Powerlevel10k"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/ryanoasis/nerd-fonts/releases/download/v${TERMUX_PKG_VERSION}/Meslo.zip
TERMUX_PKG_SHA256=6ef538a04f30af9cbe4d95fbd1ae31205a04c48a2c09714f6145ac9cbb6d1b64
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
	## Upstream Meslo ships several sizes (LGS/LGM/LGL, plus "DZ" dotted-zero
	## variants); we only ship the most popular MesloLGS Regular/Bold/Italic/
	## BoldItalic set (as used by Powerlevel10k) to keep the package small.
	mkdir -p "$TERMUX_PREFIX/share/fonts/TTF"
	cp MesloLGSNerdFont-Regular.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp MesloLGSNerdFont-Bold.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp MesloLGSNerdFont-Italic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
	cp MesloLGSNerdFont-BoldItalic.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
}
