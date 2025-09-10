TERMUX_PKG_HOMEPAGE=https://ukoethe.github.io/vigra/
TERMUX_PKG_DESCRIPTION="Computer vision library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ukoethe/vigra/archive/refs/tags/Version-${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=e927477a8a0bcdabcaab914e425782f7eba82711dbaca02538dfda79476f6b7e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="imath, libc++, libhdf5, libjpeg-turbo, libpng, libtiff, openexr, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DRUN_RESULT=0
-DRUN_RESULT__TRYRUN_OUTPUT=201103
-DWITH_OPENEXR=ON
"
TERMUX_PKG_RM_AFTER_INSTALL="doc"

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	[[ -z "${latest_tag}" ]] && termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "$(sed 's/Version-\([0-9]\+\)-\([0-9]\+\)-\([0-9]\+\)/\1.\2.\3/' <<< ${latest_tag})"
}
