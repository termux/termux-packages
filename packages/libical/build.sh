TERMUX_PKG_HOMEPAGE=https://libical.github.io/libical/
TERMUX_PKG_DESCRIPTION="Libical is an Open Source implementation of the iCalendar protocols and protocol data units"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.2"
TERMUX_PKG_SRCURL=https://github.com/libical/libical/releases/download/v$TERMUX_PKG_VERSION/libical-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=39a979bb5474af3c4601c83dc71512c1121dee56722b3d8d8668ed75bd78ccdd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libicu"
TERMUX_PKG_BREAKS="libical-dev"
TERMUX_PKG_REPLACES="libical-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLIBICAL_BUILD_DOCS=false
-DLIBICAL_GLIB=false
-DLIBICAL_GOBJECT_INTROSPECTION=false
-DUSE_BUILTIN_TZDATA=true
-DPERL_EXECUTABLE=/usr/bin/perl
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local v=$(sed -En 's/^set\(LIBICAL_LIB_MAJOR_SOVERSION\s+"?([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
