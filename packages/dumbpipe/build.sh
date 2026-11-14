TERMUX_PKG_HOMEPAGE=https://www.dumbpipe.dev/
TERMUX_PKG_DESCRIPTION="A CLI tool to pipe data over the network, with NAT hole punching"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE-APACHE
LICENSE-MIT
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.40.1"
TERMUX_PKG_SRCURL="https://github.com/n0-computer/dumbpipe/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=17bc0190772ff20a01e90d9cda6bf9a7695cfd50c0e1c3c6e146bdc8844ab62e
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
		! -wholename ./vendor/iroh-dns \
		! -wholename ./vendor/n0-dns-resolver \
		! -wholename ./vendor/netdev \
		! -wholename ./vendor/netdev-0.45.1 \
		-exec rm -rf '{}' \;

	find vendor/{rustls-platform-verifier,iroh-dns,n0-dns-resolver} -type f -print0 | \
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
		iroh-dns = { path = "./vendor/iroh-dns" }
		n0-dns-resolver = { path = "./vendor/n0-dns-resolver" }
		netdev = { path = "./vendor/netdev" }
		netdev-0-45 = { package = "netdev", path = "./vendor/netdev-0.45.1" }
	EOF
}
