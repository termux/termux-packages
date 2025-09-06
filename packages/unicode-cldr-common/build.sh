TERMUX_PKG_HOMEPAGE=http://cldr.unicode.org/
TERMUX_PKG_DESCRIPTION="Unicode Common Locale Data Repository"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="46.1"
TERMUX_PKG_SRCURL=(
	https://unicode.org/Public/cldr/$TERMUX_PKG_VERSION/cldr-common-$TERMUX_PKG_VERSION.zip
	https://unicode.org/Public/cldr/$TERMUX_PKG_VERSION/LICENSE
)
TERMUX_PKG_SHA256=(
	c3828c9280c6b3bb921bc96baf53be2174b5416d72e740ec3915c1ff91a50a80
	f5062c9a188d81dfe66b56db4182dcf9e4b17c0d9b0d311a8e20b3a1b075c443
)
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	local i
	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL[@]}-1 ))); do
		local f="$(basename "${TERMUX_PKG_SRCURL[$i]}")"
		termux_download \
			"${TERMUX_PKG_SRCURL[$i]}" \
			"$TERMUX_PKG_CACHEDIR/${f}" \
			"${TERMUX_PKG_SHA256[$i]}"
	done
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -d "$TERMUX_PKG_SRCDIR" \
		"$TERMUX_PKG_CACHEDIR/cldr-common-$TERMUX_PKG_VERSION.zip"
}

termux_step_make_install() {
	install -dm755 $TERMUX_PREFIX/share/$TERMUX_PKG_NAME
	cp -Rf $TERMUX_PKG_SRCDIR/common/* $TERMUX_PREFIX/share/$TERMUX_PKG_NAME/
}
