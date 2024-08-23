TERMUX_PKG_HOMEPAGE="https://github.com/flxzt/rnote"
TERMUX_PKG_DESCRIPTION="A simple drawing application to create handwritten notes"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL="https://github.com/flxzt/rnote/archive/v${TERMUX_PKG_VERSION}/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b133d4331963d3c09d3a7477f60fc4c5072471dcbf459379a593ca1724164af4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, gettext, glib, graphene, gtk4, hicolor-icon-theme, libadwaita, libcairo, pipewire, pango, poppler"

termux_step_pre_configure() {
	termux_setup_cmake

	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	mkdir -p "${_WRAPPER_BIN}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH="${_WRAPPER_BIN}:${PATH}"
}

termux_step_post_make_install() {
	(
		cd "${TERMUX_PKG_SRCDIR}"

		termux_setup_rust

		GETTEXT_SYSTEM=1 \
		GETTEXT_DIR="${TERMUX_PREFIX}" \
		cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--package rnote \
		--release
	)
}
