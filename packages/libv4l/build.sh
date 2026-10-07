TERMUX_PKG_HOMEPAGE=https://git.linuxtv.org/v4l-utils.git
TERMUX_PKG_DESCRIPTION="Linux libraries to handle media devices"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.32.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://linuxtv.org/downloads/v4l-utils/v4l-utils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6828828a17775526eb93fb258a9294d1d1073d633c344dd71ecd4e7a1ffb7dfc
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob, libjpeg-turbo"
TERMUX_PKG_BUILD_DEPENDS="argp, libiconv"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbpf=disabled
-Ddoxygen-doc=disabled
-Dgconv=disabled
-Djpeg=enabled
-Dlibdvbv5=disabled
-Dqv4l2=disabled
-Dqvidcap=disabled
-Dudevdir=$TERMUX_PREFIX/etc
-Dv4l2-tracer=disabled
-Dv4l-plugins=true
-Dv4l-utils=true
-Dv4l-wrappers=true
"

termux_step_post_make_install() {
	ln -sfr "$TERMUX_PREFIX/lib/libv4l/v4l1compat.so" "$TERMUX_PREFIX/lib/v4l1compat.so"
	ln -sfr "$TERMUX_PREFIX/lib/libv4l/v4l2convert.so" "$TERMUX_PREFIX/lib/v4l2convert.so"
	rm -rf "$TERMUX_PREFIX/etc/rules.d"
}
