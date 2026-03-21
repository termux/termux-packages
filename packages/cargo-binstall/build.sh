TERMUX_PKG_HOMEPAGE=https://github.com/cargo-bins/cargo-binstall
TERMUX_PKG_DESCRIPTION="Tool to fetch and install precompiled musl-based static binaries from the Rust ecosystem"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.17.8"
TERMUX_PKG_SRCURL="https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=18dbb56919f3503ccb1133192835ddb809a856c7c99212ef4066ef1cbdf08f9e
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustls-platform-verifier \
		! -wholename ./vendor/hickory-resolver \
		! -wholename ./vendor/camino \
		! -wholename ./vendor/resolv-conf \
		! -wholename ./vendor/netdev \
		-exec rm -rf '{}' \;

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	find vendor/{hickory-resolver,camino,resolv-conf,netdev} -type f -print0 | \
		xargs -0 sed -i \
		-e "s|/etc|$TERMUX_PREFIX/etc|g"

	cat >> Cargo.toml <<-EOF

		[patch.crates-io]
		rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }
		hickory-resolver = { path = "./vendor/hickory-resolver" }
		camino = { path = "./vendor/camino" }
		resolv-conf = { path = "./vendor/resolv-conf" }
		netdev = { path = "./vendor/netdev" }
	EOF
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/$CARGO_TARGET_NAME/release/$TERMUX_PKG_NAME"
}
