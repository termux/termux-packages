TERMUX_PKG_HOMEPAGE=https://unicode.org/emoji/
TERMUX_PKG_DESCRIPTION="Unicode Emoji Data Files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="copyright.html"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="16.0"
TERMUX_PKG_SRCURL=(
	https://www.unicode.org/Public/emoji/$TERMUX_PKG_VERSION/emoji-sequences.txt
	https://www.unicode.org/Public/emoji/$TERMUX_PKG_VERSION/emoji-test.txt
	https://www.unicode.org/Public/emoji/$TERMUX_PKG_VERSION/emoji-zwj-sequences.txt
)
TERMUX_PKG_SHA256=(
	3fe3c77e72e8f26df302dc7d99b106c5d08fd808ef7246fb5d4502d659fe659c
	24f0c534e86cf142e2496953e8f0e46a3e702392911eddcd29c6cced85139697
	9423ec235474356f970a696506737e2d5d65453a67f45df66b8bbe920c3fab83
)
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_SRCDIR
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
	cp $TERMUX_PKG_BUILDER_DIR/copyright.html ./
}

termux_step_make_install() {
	local f
	for f in sequences test zwj-sequences; do
		install -Dm644 $TERMUX_PKG_SRCDIR/emoji-$f.txt "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/emoji-$f.txt"
	done
}
