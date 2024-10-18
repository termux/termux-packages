TERMUX_PKG_HOMEPAGE=https://unicode.org/ucd/
TERMUX_PKG_DESCRIPTION="The Unicode Character Database (UCD)"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="copyright.html"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="16.0.0"
TERMUX_PKG_SRCURL=(
	https://unicode.org/Public/zipped/${TERMUX_PKG_VERSION}/UCD.zip
	https://unicode.org/Public/zipped/${TERMUX_PKG_VERSION}/Unihan.zip
)
TERMUX_PKG_SHA256=(
	c86dd81f2b14a43b0cc064aa5f89aa7241386801e35c59c7984e579832634eb2
	b8f000df69de7828d21326a2ffea462b04bc7560022989f7cc704f10521ef3e0
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
