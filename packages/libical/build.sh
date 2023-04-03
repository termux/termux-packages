TERMUX_PKG_HOMEPAGE=http://libical.github.io/libical/
TERMUX_PKG_DESCRIPTION="Libical is an Open Source implementation of the iCalendar protocols and protocol data units"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.16"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libical/libical/releases/download/v$TERMUX_PKG_VERSION/libical-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b44705dd71ca4538c86fb16248483ab4b48978524fb1da5097bd76aa2e0f0c33
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libicu, libxml2"
TERMUX_PKG_BREAKS="libical-dev"
TERMUX_PKG_REPLACES="libical-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DSHARED_ONLY=true -DICAL_GLIB=false -DUSE_BUILTIN_TZDATA=true -DPERL_EXECUTABLE=/usr/bin/perl"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=3

	local v=$(sed -En 's/^set\(LIBICAL_LIB_MAJOR_VERSION\s+"?([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
