TERMUX_PKG_HOMEPAGE=https://github.com/google/glog
TERMUX_PKG_DESCRIPTION="Logging library for C++"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/google/glog/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f28359aeba12f30d73d9e4711ef356dc842886968112162bc73002645139c39c
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="google-glog-dev"
TERMUX_PKG_REPLACES="google-glog-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON"

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
