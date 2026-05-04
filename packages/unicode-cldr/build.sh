TERMUX_PKG_HOMEPAGE=http://cldr.unicode.org/
TERMUX_PKG_DESCRIPTION="Unicode Common Locale Data Repository"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.1"
TERMUX_PKG_SRCURL="https://unicode.org/Public/cldr/$TERMUX_PKG_VERSION/cldr-common-$TERMUX_PKG_VERSION.zip"
TERMUX_PKG_SHA256=c691e94f217486fed259871429ae71cc4855e8a7f22b1586eb6eb52262c9c307
TERMUX_PKG_PLATFORM_INDEPENDENT=true

# Extract like libncnn
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -q "$file" -d "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	install -dm755 "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME"
	cp -Rf "$TERMUX_PKG_SRCDIR"/common/* "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/"
}
