TERMUX_PKG_HOMEPAGE=https://github.com/ikatson/rqbit
TERMUX_PKG_DESCRIPTION="A bittorrent command line client and server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="DevGitPit <106362593+DevGitPit@users.noreply.github.com>"
TERMUX_PKG_VERSION="9.0.0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_SRCURL="https://github.com/ikatson/rqbit/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a5c549c35e5a1e643e67376fd465158421a57e600594b69438f444b804fb6f34
TERMUX_PKG_BUILD_DEPENDS="nodejs"
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_NO_VENDOR=1

	termux_setup_rust
	termux_setup_nodejs
}

termux_step_make_install() {
	cargo install \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--path crates/rqbit \
		--force \
		--locked \
		--no-track \
		--target "$CARGO_TARGET_NAME" \
		--root "$TERMUX_PREFIX"
}
