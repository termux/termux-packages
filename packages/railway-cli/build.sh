TERMUX_PKG_HOMEPAGE=https://railway.app
TERMUX_PKG_DESCRIPTION="This is the command line interface for Railway"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.62.0"
TERMUX_PKG_SRCURL="https://github.com/railwayapp/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2753b88aa5bd5e2342cea9efc35623a2ae912fe6dd9c0170f83f67154b1eb85a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/arboard \
		! -wholename ./vendor/x11rb-protocol \
		! -wholename ./vendor/termios \
		! -wholename ./vendor/termios-0.2.2 \
		-exec rm -rf '{}' \;

	find vendor/{arboard,x11rb-protocol} -type f -print0 | \
		xargs -0 sed -i \
		-e 's|android|disabling_this_because_it_is_for_building_an_apk|g' \
		-e "s|/tmp|$TERMUX_PREFIX/tmp|g"

	find vendor/termios vendor/termios-0.2.2 -type f -name '*.rs' -print0 | \
		xargs -0 sed -i \
		-e 's/target_os = "linux"/any(target_os = "linux", target_os = "android")/g'

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo "arboard = { path = \"./vendor/arboard\" }" >> Cargo.toml
	echo "x11rb-protocol = { path = \"./vendor/x11rb-protocol\" }" >> Cargo.toml
	echo "termios = { path = \"./vendor/termios\" }" >> Cargo.toml
	# A `[patch.crates-io]` table can only have one entry per crate name,
	# so the second termios version is patched under a different TOML
	# key with an explicit `package =` to tell Cargo which crate it's
	# really for (see "Multiple patch locations" in the Cargo book).
	echo "termios_0_2 = { path = \"./vendor/termios-0.2.2\", package = \"termios\" }" >> Cargo.toml
}
