TERMUX_PKG_HOMEPAGE="https://github.com/flxzt/rnote"
TERMUX_PKG_DESCRIPTION="An infinite canvas vector-based drawing application for handwritten notes"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@EDLLT"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/flxzt/rnote/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b133d4331963d3c09d3a7477f60fc4c5072471dcbf459379a593ca1724164af4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, gettext, glib, graphene, gtk4, hicolor-icon-theme, libadwaita, libcairo, pipewire, pango, poppler"
TERMUX_PKG_BUILD_DEPENDS="libiconv"
TERMUX_PKG_PYTHON_BUILD_DEPS="toml2json"

__fetch_gettext_rs() {
	# Latest version of gettext-sys, provided by the gettext-rs crate
	local crate_version=0.21.4
	local -a crate=(
		"https://github.com/gettext-rs/gettext-rs/archive/refs/tags/gettext-sys-$crate_version.tar.gz" # Upstream URL
		"$TERMUX_PKG_CACHEDIR/gettext-v$crate_version.tar.gz"                                          # Local save path
		'211773408ab61880b94a0ea680785fc21fad307cd42594d547cf5a056627fcda'                             # SHA256 checksum
	)

	# Fetch latest gettext from upstream
	local -a upstream=(
		"$(. "$TERMUX_SCRIPTDIR/packages/gettext/build.sh"; echo ${TERMUX_PKG_SRCURL})"   # Upstream URL (from gettext's build script)
		"$TERMUX_PKG_SRCDIR/gettext-source/gettext-sys/gettext-latest.tar.xz"             # Local save path
		"$(. "$TERMUX_SCRIPTDIR/packages/gettext/build.sh"; echo ${TERMUX_PKG_SHA256})"   # SHA256 checksum (from gettext's build script)
	)

	termux_download "${crate[@]}"

	tar xf "${crate[1]}" -C "$TERMUX_PKG_SRCDIR"
	mv "gettext-rs-gettext-sys-$crate_version" "gettext-source"

	termux_download "${upstream[@]}"
}

__patch_gettext_rs() {
	# Patch gettext-rs crate to use a newer gettext version because the old one doesn't compile properly with clang
	patch -p1 -d "$TERMUX_PKG_SRCDIR/gettext-source" -i "$TERMUX_PKG_BUILDER_DIR"/gettext-rs-crate.diff
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_glib_cross_pkg_config_wrapper

	# Fetch and patch the crate to use a newer upstream gettext version
	__fetch_gettext_rs
	__patch_gettext_rs
}

termux_step_make() {
	termux_setup_rust
	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-liconv"

	cd "${TERMUX_PKG_SRCDIR}" || termux_error_exit "Failed to enter source directory, aborting build."
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
