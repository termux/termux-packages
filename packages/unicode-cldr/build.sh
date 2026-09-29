TERMUX_PKG_HOMEPAGE=http://cldr.unicode.org/
TERMUX_PKG_DESCRIPTION="Unicode Common Locale Data Repository"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.2"
TERMUX_PKG_SRCURL="https://unicode.org/Public/cldr/$TERMUX_PKG_VERSION/cldr-common-$TERMUX_PKG_VERSION.zip"
TERMUX_PKG_SHA256=d2844f9dbf6124d11a7b047f5381a467902d82a673be3d658f4c0791ffa0b83b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

# Extract like libncnn
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -q "$file" -d "$TERMUX_PKG_SRCDIR"
}

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(termux_repology_api_get_latest_version "${TERMUX_PKG_NAME}")"
	if [[ "${latest_version}" == "null" ]] || [[ ! "${latest_version}" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
		echo "INFO: Already up to date."
		return 0
	fi
	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_make_install() {
	install -dm755 "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME"
	cp -Rf "$TERMUX_PKG_SRCDIR"/common/* "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/"
}
