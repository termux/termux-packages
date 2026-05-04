TERMUX_PKG_HOMEPAGE=https://unicode.org/ucd/
TERMUX_PKG_DESCRIPTION="The Unicode Character Database (UCD)"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="copyright.html"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.0.0"
TERMUX_PKG_SRCURL=(
	https://unicode.org/Public/${TERMUX_PKG_VERSION}/ucd/UCD.zip
	https://unicode.org/Public/${TERMUX_PKG_VERSION}/ucd/Unihan.zip
)
TERMUX_PKG_SHA256=(
	c961d4405edd144b5052cfaf8bf7db54af44ebc5db7181f83c6c52df99e9363a
	835593ec1ca206486cdef6860a41930343ac014d7d61f7f7ef2b25084fadbdd4
)
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology

termux_step_get_source() {
	local i
	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL[@]}-1 ))); do
		local f="${TERMUX_PKG_NAME}-$(basename "${TERMUX_PKG_SRCURL[$i]}")"
		termux_download \
			"${TERMUX_PKG_SRCURL[$i]}" \
			"$TERMUX_PKG_CACHEDIR/${f}" \
			"${TERMUX_PKG_SHA256[$i]}"
	done
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -d "$TERMUX_PKG_SRCDIR" \
		"$TERMUX_PKG_CACHEDIR/${TERMUX_PKG_NAME}-UCD.zip"
	cp "$TERMUX_PKG_CACHEDIR/${TERMUX_PKG_NAME}-Unihan.zip" \
		"$TERMUX_PKG_SRCDIR/Unihan.zip"
}

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/copyright.html ./
}

termux_step_make_install() {
	cp -rT "$TERMUX_PKG_SRCDIR" "$TERMUX_PREFIX/share/${TERMUX_PKG_NAME}"
}
