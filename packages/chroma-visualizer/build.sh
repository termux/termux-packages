TERMUX_PKG_HOMEPAGE=https://github.com/yuri-xyz/chroma.git
TERMUX_PKG_DESCRIPTION="Shader-based audio visualizer for the terminal"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.0.20260922+g1b98379"
TERMUX_PKG_SRCURL="https://github.com/yuri-xyz/chroma/archive/${TERMUX_PKG_VERSION##*+g}.tar.gz"
TERMUX_PKG_SHA256=59a7ba7283ec17eea3e4abc8383433d3f50d8eeb1a0d4928ee739bad0d22d92a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="vulkan-icd, alsa-lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features audio"

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cpal \
		! -wholename ./vendor/wgpu \
		! -wholename ./vendor/wgpu-hal \
		-exec rm -rf '{}' \;

	find \
		vendor/cpal \
		vendor/wgpu \
		vendor/wgpu-hal \
		-type f -print0 | \
		xargs -0 sed -i \
		-e 's|\\"android\\"|\\"disabling_this_because_it_is_for_building_an_apk\\"|g' \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e 's|\\"linux\\"|\\"android\\"|g' \
		-e 's|"linux"|"android"|g'

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'cpal = { path = "./vendor/cpal" }' >> Cargo.toml
	echo 'wgpu = { path = "./vendor/wgpu" }' >> Cargo.toml
	echo 'wgpu-hal = { path = "./vendor/wgpu-hal" }' >> Cargo.toml
}
