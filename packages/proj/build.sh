TERMUX_PKG_HOMEPAGE=https://proj.org
TERMUX_PKG_DESCRIPTION="Generic coordinate transformation software"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION="9.3.0"
TERMUX_PKG_SRCURL=https://github.com/OSGeo/proj.4/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f48c334eaf56c38d681bcfa37f188f422a562f45a66e6e646a79b4249641ecdb
TERMUX_PKG_DEPENDS="libc++, libsqlite, sqlite, libtiff, libcurl"
TERMUX_PKG_BREAKS="proj-dev"
TERMUX_PKG_REPLACES="proj-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=25

	local v=$(sed -En 's/^set\(PROJ_SOVERSION\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
