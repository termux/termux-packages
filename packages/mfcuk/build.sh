TERMUX_PKG_HOMEPAGE=https://github.com/nfc-tools/mfcuk
TERMUX_PKG_DESCRIPTION="MiFare Classic Universal toolKit (MFCUK)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=b333a7925a3be80d9496c88c9fef816777827a83
TERMUX_PKG_VERSION=2018.07.14
TERMUX_PKG_SRCURL=git+https://github.com/nfc-tools/mfcuk
TERMUX_PKG_SHA256=1ceec471a8cd0cfb50dd19e022f7f019bb2892285c9354403c98d5b0f94ef9af
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libnfc"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}
