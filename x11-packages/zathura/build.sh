TERMUX_PKG_HOMEPAGE="https://pwmt.org/projects/zathura/"
TERMUX_PKG_DESCRIPTION="A lightweight document viewer"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.07.18"
TERMUX_PKG_SRCURL="https://github.com/pwmt/zathura/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=737911eaf3ff7047004e0cb68548365313f072c3522b89efa0e4b7a036730b80
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="desktop-file-utils, girara, glib, gtk4, json-glib, libmagic, libseccomp, libsynctex, sqlite, xxhash"
# Added after current release (2026.07.18).
# https://github.com/pwmt/zathura/commit/751832af6dfa8b2b6b5fcdf75c94f83c64739f89
# Enable when new release is published.
# The build deps can also be removed at that time.
# -Dshell-completions=enabled
TERMUX_PKG_BUILD_DEPENDS="bash-completion, fish"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-Dmanpages=enabled
	-Dseccomp=enabled
	-Dlandlock=disabled
	-Dsynctex=enabled
"


termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_glib_cross_pkg_config_wrapper

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		# `rsvg-convert` is used during the build to convert the SVG icon
		# to additional PNG icons at fixed resolution.
		DESTINATION="${TERMUX_PKG_TMPDIR}/ubuntu_packages" \
		termux_download_ubuntu_packages "librsvg2-bin" "librsvg2-2"
		local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper_bin"
		mkdir -p "${_WRAPPER_BIN}"
		cat <<-EOF > "${_WRAPPER_BIN}/rsvg-convert"
			#!/bin/sh
			export LD_LIBRARY_PATH="${TERMUX_PKG_TMPDIR}/ubuntu_packages/usr/lib/x86_64-linux-gnu"
			exec "${TERMUX_PKG_TMPDIR}/ubuntu_packages/usr/bin/rsvg-convert" "\$@"
		EOF
		chmod +x "${_WRAPPER_BIN}/rsvg-convert"
		export PATH="${_WRAPPER_BIN}:${PATH}"
	fi
}
