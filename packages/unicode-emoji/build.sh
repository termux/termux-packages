TERMUX_PKG_HOMEPAGE=https://unicode.org/emoji/
TERMUX_PKG_DESCRIPTION="Unicode Emoji Data Files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="copyright.html"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="17.0.0"
TERMUX_PKG_SRCURL=(
	https://www.unicode.org/Public/$TERMUX_PKG_VERSION/emoji/emoji-sequences.txt
	https://www.unicode.org/Public/$TERMUX_PKG_VERSION/emoji/emoji-test.txt
	https://www.unicode.org/Public/$TERMUX_PKG_VERSION/emoji/emoji-zwj-sequences.txt
)
TERMUX_PKG_SHA256=(
	12cc8267dc33cbd11ed32bcf6fc5dc2ad9c7a77bae1bdfba2f41b1b9b3ead8dd
	1d8a944f88d7952f7ef7c5167fef3c67995bcae24543949710231b03a201acda
	5b25441daed2322b068c5e70cda522946a4f0274df864445a1965a92e5fc5cad
)
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	local i
	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL[@]}-1 ))); do
		local bn="$(basename "${TERMUX_PKG_SRCURL[$i]}")"
		local f="${TERMUX_PKG_VERSION}-${bn}"
		termux_download \
			"${TERMUX_PKG_SRCURL[$i]}" \
			"$TERMUX_PKG_CACHEDIR/${f}" \
			"${TERMUX_PKG_SHA256[$i]}"
		cp "$TERMUX_PKG_CACHEDIR/${f}" "$TERMUX_PKG_SRCDIR/${bn}"
	done
}

termux_step_post_get_source() {
	cp "$TERMUX_PKG_BUILDER_DIR"/copyright.html ./
}

termux_step_make_install() {
	local f
	for f in sequences test zwj-sequences; do
		install -Dm644 "$TERMUX_PKG_SRCDIR/emoji-$f.txt" "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/emoji-$f.txt"
	done
}
