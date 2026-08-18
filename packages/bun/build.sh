TERMUX_PKG_HOMEPAGE=https://bun.com
TERMUX_PKG_DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.3.14"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_EXCLUDED_ARCHES="arm,i686"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	local _BUN_ARCH
	local _BUN_SHA256

	case "$TERMUX_ARCH" in
		aarch64)
			_BUN_ARCH=aarch64
			_BUN_SHA256=992bcf239c91bedd873f8150cceef3db3b0618fa78161badd3c14dc6d24fe560
			;;
		x86_64)
			_BUN_ARCH=x64
			_BUN_SHA256=9ce0fccae24c55c5e59f6ee87c6defd8c79d0dc8a9ad2c214abd177c23c31d27
			;;
	esac

	local URL="https://github.com/oven-sh/bun/releases/download/bun-v${TERMUX_PKG_VERSION}/bun-linux-${_BUN_ARCH}-android.zip"
	local FILE="$TERMUX_PKG_CACHEDIR/bun-${TERMUX_PKG_VERSION}-${_BUN_ARCH}.zip"

	termux_download "$URL" "$FILE" "$_BUN_SHA256"

	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -q "$FILE" -d "$TERMUX_PKG_SRCDIR"
	mv "$TERMUX_PKG_SRCDIR"/bun-linux-${_BUN_ARCH}-android/* "$TERMUX_PKG_SRCDIR"/
}

termux_step_make() {
	: # prebuilt binary
}

termux_step_make_install() {
	install -Dm755 \
		"$TERMUX_PKG_SRCDIR/bun" \
		"$TERMUX_PREFIX/bin/bun"
}

termux_step_post_get_source() {
	curl -fsSL "https://raw.githubusercontent.com/oven-sh/bun/main/LICENSE.md" -o "$TERMUX_PKG_SRCDIR/LICENSE"
}
