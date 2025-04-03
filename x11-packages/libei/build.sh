TERMUX_PKG_HOMEPAGE=https://libinput.pages.freedesktop.org/libei/
TERMUX_PKG_DESCRIPTION="Library for Emulated Input"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.1"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/libinput/libei/-/archive/$TERMUX_PKG_VERSION/libei-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d0e8f18eb3617fbcc3d860bb54a47e17709e94e8e7cb0ae01ae221c67f000872
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibei=enabled
-Dlibeis=enabled
-Dliboeffis=disabled
-Dtests=disabled
"

termux_step_pre_configure() {
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libei.so.1
lib/libeis.so.1
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
