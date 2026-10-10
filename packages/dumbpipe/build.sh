TERMUX_PKG_HOMEPAGE=https://www.dumbpipe.dev/
TERMUX_PKG_DESCRIPTION="A CLI tool to pipe data over the network, with NAT hole punching"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE-APACHE
LICENSE-MIT
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.39.0"
TERMUX_PKG_SRCURL="https://github.com/n0-computer/dumbpipe/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=89d01b0b6d25fc8baf06ab791fd0a2b35b24ac51d0bd01b64d36c35750aaf3e9
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export CARGO_PROFILE_RELEASE_PANIC=unwind
	termux_setup_rust

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
