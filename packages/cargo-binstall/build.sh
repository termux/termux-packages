TERMUX_PKG_HOMEPAGE=https://github.com/cargo-bins/cargo-binstall
TERMUX_PKG_DESCRIPTION="Tool to fetch and install precompiled musl-based static binaries from the Rust ecosystem"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.25.3"
TERMUX_PKG_SRCURL="https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=4a570a613cece4b831f1d00fa16e73100542d067df9415e5a560940f0e0911cc
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	# jitterentropy needs -O0, which -Oz in CFLAGS overrides
	export AWS_LC_SYS_NO_JITTER_ENTROPY=1

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustls-platform-verifier \
		! -wholename ./vendor/hickory-resolver \
		! -wholename ./vendor/resolv-conf \
		! -wholename ./vendor/netdev \
		-exec rm -rf '{}' \;

	find vendor/{rustls-platform-verifier,hickory-resolver} -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	find . -type f -print0 | \
		xargs -0 sed -i \
		-e "s|/etc|$TERMUX_PREFIX/etc|g"

	cat >> Cargo.toml <<-EOF

		[patch.crates-io]
		rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }
		hickory-resolver = { path = "./vendor/hickory-resolver" }
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
