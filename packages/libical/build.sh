TERMUX_PKG_HOMEPAGE=https://libical.github.io/libical/
TERMUX_PKG_DESCRIPTION="Libical is an Open Source implementation of the iCalendar protocols and protocol data units"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.7"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libical/libical/releases/download/v$TERMUX_PKG_VERSION/libical-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=47c05bc96e41416578cf1803bb2ba3f8d292cb17d5ac2fca539dee922bae8a94
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libc++, libicu, libxml2"
TERMUX_PKG_BREAKS="libical-dev"
TERMUX_PKG_REPLACES="libical-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLIBICAL_BUILD_DOCS=false
-DLIBICAL_GLIB=true
-DLIBICAL_GLIB_BUILD_DOCS=false
-DLIBICAL_GOBJECT_INTROSPECTION=false
-DUSE_BUILTIN_TZDATA=true
-DPERL_EXECUTABLE=/usr/bin/perl
-DIMPORT_ICAL_GLIB_SRC_GENERATOR=$TERMUX_PKG_HOSTBUILD_DIR/host-prefix/lib/cmake/LibIcal/IcalGlibSrcGenerator.cmake
-DENABLE_GTK_DOC=false
"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR"/host-prefix

	cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PKG_HOSTBUILD_DIR"/host-prefix \
		-DLIBICAL_GLIB=True \
		-DLIBICAL_GLIB_BUILD_DOCS=False \
		-DLIBICAL_GOBJECT_INTROSPECTION=False \
		-DENABLE_GTK_DOC=OFF \
		-G Ninja \
		"$TERMUX_PKG_SRCDIR"
	cmake --build .
	cmake --install . --prefix "$TERMUX_PKG_HOSTBUILD_DIR"/host-prefix
}

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
