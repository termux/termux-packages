TERMUX_PKG_HOMEPAGE="https://github.com/poljar/weechat-matrix-rs"
TERMUX_PKG_DESCRIPTION="Rust rewrite of the python weechat-matrix script"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=ca23e1745e6e2ba235550360e1def1457e2f3857
TERMUX_PKG_VERSION=2022.10.04
TERMUX_PKG_SRCURL="git+https://github.com/poljar/weechat-matrix-rs"
TERMUX_PKG_SHA256=61d4d307167f274c1ee165a7021d5cda330a2331eb89e8add2f027becf8cae0c
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="weechat, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
# There are compile errors for 32-bit platforms in weechat-rust dependency
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

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

termux_step_make() {
	termux_setup_rust
	# cmake is needed for building of olm-sys by cargo internally
	termux_setup_cmake

	# olm-sys needs the path to Android NDK to be built
	export ANDROID_NDK="$NDK"
	# force the plugin to be built against the weechat SDK available in packages
	export WEECHAT_PLUGIN_FILE="$TERMUX_PREFIX/include/weechat/weechat-plugin.h"
	WEECHAT_PLUGIN_API_VERSION=$(grep 'define WEECHAT_PLUGIN_API_VERSION' \
		"$WEECHAT_PLUGIN_FILE" | cut -d " " -f 3 | tr -d '"')
	printf "WeeChat Plugin API version: %s \n" "$WEECHAT_PLUGIN_API_VERSION"
	[[ -z "$WEECHAT_PLUGIN_API_VERSION" ]] && exit 1

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 target/${CARGO_TARGET_NAME}/release/libmatrix.so \
		"$TERMUX_PREFIX/lib/weechat/plugins/matrix.so"
}
