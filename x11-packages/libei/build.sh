TERMUX_PKG_HOMEPAGE=https://libinput.pages.freedesktop.org/libei/
TERMUX_PKG_DESCRIPTION="Library for Emulated Input"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/libinput/libei/-/archive/$TERMUX_PKG_VERSION/libei-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=81b4b967f0e5938492434a04f7ea2e6c6d96d3e6c44700bc691821f82281e602
TERMUX_PKG_AUTO_UPDATE=true
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
