TERMUX_PKG_HOMEPAGE=https://github.com/edghyhdz/crypto_monitor
TERMUX_PKG_DESCRIPTION="Real-time crypto currency monitor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=86fd7de705babc2cef1e920e39ec439f5aa9c336
TERMUX_PKG_VERSION=2021.02.22
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=git+https://github.com/edghyhdz/crypto_monitor
TERMUX_PKG_SHA256=df67d1a0de5f547cab78dbc977609d1b24f5c2ed8e3fc0619734d3e36ac4a1bc
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="libc++, libcurl, ncurses-ui-libs, openssl"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_BUILD_IN_SRC=true

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

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin executable/crypto_monitor
}
