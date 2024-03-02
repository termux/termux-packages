TERMUX_PKG_HOMEPAGE=https://github.com/google/glog
TERMUX_PKG_DESCRIPTION="Logging library for C++"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL=https://github.com/google/glog/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=375106b5976231b92e66879c1a92ce062923b9ae573c42b56ba28b112ee4cc11
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gflags, libc++"
TERMUX_PKG_BUILD_DEPENDS="gflags-static"
TERMUX_PKG_BREAKS="google-glog-dev"
TERMUX_PKG_REPLACES="google-glog-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local v=$(sed -En 's/^\s*set_target_properties\s*\(glog\s+.*\s+SOVERSION\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}

termux_step_post_make_install() {
	install -Dm600 "$TERMUX_PKG_SRCDIR"/libglog.pc.in \
		"$TERMUX_PREFIX"/lib/pkgconfig/libglog.pc
	sed -i "s|@prefix@|$TERMUX_PREFIX|g" "$TERMUX_PREFIX"/lib/pkgconfig/libglog.pc
	sed -i "s|@exec_prefix@|$TERMUX_PREFIX|g" "$TERMUX_PREFIX"/lib/pkgconfig/libglog.pc
	sed -i "s|@libdir@|$TERMUX_PREFIX/lib|g" "$TERMUX_PREFIX"/lib/pkgconfig/libglog.pc
	sed -i "s|@includedir@|$TERMUX_PREFIX/include|g" "$TERMUX_PREFIX"/lib/pkgconfig/libglog.pc
	sed -i "s|@VERSION@|$TERMUX_PKG_VERSION|g" "$TERMUX_PREFIX"/lib/pkgconfig/libglog.pc
}
