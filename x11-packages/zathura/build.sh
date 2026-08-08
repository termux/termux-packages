TERMUX_PKG_HOMEPAGE="https://pwmt.org/projects/zathura/"
TERMUX_PKG_DESCRIPTION="A lightweight document viewer"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.07.18"
TERMUX_PKG_SRCURL="https://github.com/pwmt/zathura/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=737911eaf3ff7047004e0cb68548365313f072c3522b89efa0e4b7a036730b80
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="desktop-file-utils, file, girara, glib, gtk4, json-glib, libseccomp, libsynctex, sqlite, xxhash"
# Added after current release (2026.07.18).
# https://github.com/pwmt/zathura/commit/751832af6dfa8b2b6b5fcdf75c94f83c64739f89
# Enable when new release is published.
# The build deps can also be removed at that time.
# -Dshell-completions=enabled
TERMUX_PKG_BUILD_DEPENDS="bash-completion, fish"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-Dmanpages=enabled
	-Dseccomp=enabled
	-Dsynctex=enabled
"


termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_glib_cross_pkg_config_wrapper

	# Used during the build to convert the SVG icon
	# to additional PNG icons at fixed resolution.
	termux_download_ubuntu_packages "librsvg2-bin"
}
