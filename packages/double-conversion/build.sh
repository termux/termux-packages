TERMUX_PKG_HOMEPAGE=https://github.com/google/double-conversion
TERMUX_PKG_DESCRIPTION="Binary-decimal and decimal-binary routines for IEEE doubles"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/google/double-conversion/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fe54901055c71302dcdc5c3ccbe265a6c191978f3761ce1414d0895d6b0ea90e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=3

	local v=$(sed -En 's/^\s*set_target_properties\(double-conversion\s+.*\s+SOVERSION\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
