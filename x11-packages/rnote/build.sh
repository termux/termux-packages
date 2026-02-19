TERMUX_PKG_HOMEPAGE="https://github.com/flxzt/rnote"
TERMUX_PKG_DESCRIPTION="An infinite canvas vector-based drawing application for handwritten notes"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@EDLLT"
TERMUX_PKG_VERSION="0.13.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/flxzt/rnote/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1d281a17ff8b9dce325ae5b0613a0cd7db5d717319f4899f2ce758e615572256
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="alsa-lib, gdk-pixbuf, gettext, glib, graphene, gtk4, hicolor-icon-theme, libadwaita, libcairo, pipewire, pango, poppler"
TERMUX_PKG_BUILD_DEPENDS="libiconv"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="toml2json"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_make() {
	termux_setup_rust

	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-liconv"

	cd "${TERMUX_PKG_SRCDIR}" || termux_error_exit "Failed to enter source directory, aborting build."
	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cpal \
		-exec rm -rf '{}' \;

	find vendor/cpal -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e 's|"linux"|"android"|g'

	sed -i '/\[patch.crates-io\]/a cpal = { path = "./vendor/cpal" }' Cargo.toml

	local target
	for target in 'rnote-cli' 'rnote'; do
		cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--package "${target}" \
		--release
	done
}

termux_step_post_make_install() {
	install -Dm755 "${TERMUX_PKG_SRCDIR}/target/$CARGO_TARGET_NAME/release/rnote-cli" -t "$TERMUX_PREFIX/bin"
	install -Dm755 "${TERMUX_PKG_SRCDIR}/target/$CARGO_TARGET_NAME/release/rnote" -t "$TERMUX_PREFIX/bin"
}
