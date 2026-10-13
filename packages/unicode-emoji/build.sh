TERMUX_PKG_HOMEPAGE=https://unicode.org/emoji/
TERMUX_PKG_DESCRIPTION="Unicode Emoji Data Files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="copyright.html"
TERMUX_PKG_MAINTAINER="@termux"
# Revbump revdeps after updating
TERMUX_PKG_VERSION="18.0.0"
TERMUX_PKG_SRCURL=(
	https://www.unicode.org/Public/$TERMUX_PKG_VERSION/emoji/emoji-sequences.txt
	https://www.unicode.org/Public/$TERMUX_PKG_VERSION/emoji/emoji-test.txt
	https://www.unicode.org/Public/$TERMUX_PKG_VERSION/emoji/emoji-zwj-sequences.txt
)
TERMUX_PKG_SHA256=(
	1823dce71f3dd9cb0ad1976797baee4ffbdc1909756f43af8ce4c57f732843a4
	8f3735cda1f92a779d78af67cf86066bb1f07143dc22f2ac29394d9bc57ab21a
	f61b5213bdf85a57741a9f903cb38d0f39a3d13be6ff4aca3b39857e859a9191
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
