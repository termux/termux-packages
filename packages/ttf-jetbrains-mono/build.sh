TERMUX_PKG_HOMEPAGE=https://www.jetbrains.com/lp/mono/
TERMUX_PKG_DESCRIPTION="A free and open-source typeface for developers"
TERMUX_PKG_LICENSE="OFL-1.1"
TERMUX_PKG_LICENSE_FILE="OFL.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.304
TERMUX_PKG_SRCURL=https://github.com/JetBrains/JetBrainsMono/releases/download/v$TERMUX_PKG_VERSION/JetBrainsMono-$TERMUX_PKG_VERSION.zip
TERMUX_PKG_SHA256=6f6376c6ed2960ea8a963cd7387ec9d76e3f629125bc33d1fdcd7eb7012f7bbf
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

# The original "termux_extract_src_archive" always strips away fonts/webfonts
# but the fonts we want are in fonts/ttf
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -q "$file" -d "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	## Install fonts.
	mkdir -p "$TERMUX_PREFIX/share/fonts/TTF"
	cp fonts/ttf/*.ttf "$TERMUX_PREFIX/share/fonts/TTF/"
}
