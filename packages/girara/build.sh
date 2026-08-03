TERMUX_PKG_HOMEPAGE="https://pwmt.org/projects/girara"
TERMUX_PKG_DESCRIPTION="Simple user interface library used by Zathura"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.07.18"
TERMUX_PKG_SRCURL="https://github.com/pwmt/girara/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=841ca1d6fc33f87ca0065208052dffd7c49489cfd1119ce572176c1d5428a1e0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="glib"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper

	# ../src/tests/test_utils.c:21:16: error: use of undeclared identifier 'getpwent'
	#    21 |   while ((pw = getpwent()) != NULL) {
	#       |                ^
	# 1 error generated.
	#
	# Disable tests, to avoid above mentioned build error.
	sed -i "s/subdir('tests')//" "$TERMUX_PKG_SRCDIR/meson.build"
}
