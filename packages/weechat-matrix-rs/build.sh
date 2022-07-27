TERMUX_PKG_HOMEPAGE="https://github.com/poljar/weechat-matrix-rs"
TERMUX_PKG_DESCRIPTION="Rust rewrite of the python weechat-matrix script"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL="https://github.com/poljar/weechat-matrix-rs.git"
TERMUX_PKG_GIT_BRANCH="master"
_COMMIT="dd6701910e687ed1ea3d768844a902cfd2ff8231"
TERMUX_PKG_VERSION="2022.04.17"
TERMUX_PKG_DEPENDS="weechat, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
# There are compile errors for 32-bit platforms in weechat-rust dependency
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --date=format:"%Y.%m.%d" --format="%ad")"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_make() {
	termux_setup_rust
	# cmake is needed for building of olm-sys by cargo internally
	termux_setup_cmake

	# olm-sys needs the path to Android NDK to be built
	export ANDROID_NDK="$NDK"
	# force the plugin to be built against the weechat SDK available in packages
	export WEECHAT_PLUGIN_API_VERSION="$TERMUX_PREFIX/usr/include/weechat/weechat-plugin.h"

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 target/${CARGO_TARGET_NAME}/release/libmatrix.so \
		"$TERMUX_PREFIX/usr/lib/weechat/plugins/matrix.so"
}
