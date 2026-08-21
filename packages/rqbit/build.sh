TERMUX_PKG_HOMEPAGE=https://github.com/ikatson/rqbit
TERMUX_PKG_DESCRIPTION="A bittorrent command line client and server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="DevGitPit <106362593+DevGitPit@users.noreply.github.com>"
TERMUX_PKG_VERSION="9.0.1"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_SRCURL="https://github.com/ikatson/rqbit/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=62a42c56259b737eea6580b63061589dc9940b145c40991cfff83470aa783291
TERMUX_PKG_BUILD_DEPENDS="nodejs"
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_NO_VENDOR=1

	termux_setup_rust
	termux_setup_nodejs

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustls-platform-verifier \
		-exec rm -rf '{}' \;

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' >> Cargo.toml
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
