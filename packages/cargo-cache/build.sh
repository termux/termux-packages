TERMUX_PKG_HOMEPAGE=https://github.com/matthiaskrgr/cargo-cache
TERMUX_PKG_DESCRIPTION="Tool to manage cargo cache"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.3"
TERMUX_PKG_SRCURL="https://github.com/matthiaskrgr/cargo-cache/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d0f71214d17657a27e26aef6acf491bc9e760432a9bc15f2571338fcc24800e4
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/libgit2-sys \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d vendor/libgit2-sys \
		< "$TERMUX_PKG_BUILDER_DIR/libgit2-sys-getloadavg.diff"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'libgit2-sys = { path = "./vendor/libgit2-sys" }' >> Cargo.toml
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/$CARGO_TARGET_NAME/release/$TERMUX_PKG_NAME"
}
