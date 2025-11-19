TERMUX_PKG_HOMEPAGE="https://github.com/OctoMap/octomap"
TERMUX_PKG_DESCRIPTION="An efficient probabilistic 3D mapping framework based on octrees"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="octomap/LICENSE.txt"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="1.10.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/OctoMap/octomap/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=8da2576ec6a0993e8900db7f91083be8682d8397a7be0752c85d1b7dd1b8e992
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_FORCE_CMAKE=true

# disable GUI subprojects
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_OCTOVIS_SUBPROJECT=OFF
-DBUILD_DYNAMICETD3D_SUBPROJECT=ON
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DOCTOVIS_QT5=OFF
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1.10

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1-2)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
