TERMUX_PKG_HOMEPAGE=http://www.ece.uvic.ca/~frodo/jasper/
TERMUX_PKG_DESCRIPTION="Library for manipulating JPEG-2000 files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.0"
TERMUX_PKG_SRCURL=https://github.com/jasper-software/jasper/archive/refs/tags/version-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c9a3e35c95447f530b006fab6634a2dadec70276cc3e42c343b9e5ce5a1f2b6b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_BREAKS="libjasper-dev"
TERMUX_PKG_REPLACES="libjasper-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-H$TERMUX_PKG_SRCDIR
-B$TERMUX_PKG_BUILDDIR
-DJAS_STDC_VERSION=201112L
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=7

	local v="$(sed -En 's/^.*set\(JAS_SO_VERSION ([0-9]+).*$/\1/p' \
			CMakeLists.txt)"
	if [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "Error: SOVERSION guard check failed."
	fi
}
