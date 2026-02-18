TERMUX_PKG_HOMEPAGE=http://taglib.github.io/
TERMUX_PKG_DESCRIPTION="A Library for reading and editing the meta-data of several popular audio formats."
# License: LGPL-2.1, MPL-1.1
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING.LGPL, COPYING.MPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2"
TERMUX_PKG_SRCURL="https://github.com/taglib/taglib/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=96f4e78a5d33c204b01389840951ba8aba6e80fb35323dcd51c10de03f974336
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zlib, utf8cpp"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_BREAKS="taglib-dev"
TERMUX_PKG_REPLACES="taglib-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DBUILD_SHARED_LIBS=ON
-DWITH_MP4=ON
-DWITH_ASF=ON
-DWITH_DSF=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local v=$(sed -En 's/^set\(TAGLIB_SOVERSION_MAJOR\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
