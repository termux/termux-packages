TERMUX_PKG_HOMEPAGE=http://www.netsurf-browser.org/
TERMUX_PKG_DESCRIPTION="NetSurf is a free, open source web browser"
TERMUX_PKG_LICENSE="MIT, GPL-2.0"
TERMUX_PKG_LICENSE_FILE="netsurf/COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.10
TERMUX_PKG_SRCURL=http://download.netsurf-browser.org/netsurf/releases/source-full/netsurf-all-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=495adf6b6614ce36fca6c605f7c321f9cb4a3df838043158122678ce2b3325b7
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libcurl, libexpat, libiconv, libjpeg-turbo, libpng, librsvg, libwebp, openssl, pango, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export TARGET=gtk3
}

termux_step_configure () {
	echo CC=$CC
	export HOST=`$CC -dumpmachine`
	export BUILD=`$CC_FOR_BUILD -dumpmachine`
	export CFLAGS+=" -I${TERMUX_PREFIX}/include"
	export CPPFLAGS+=" -I${TERMUX_PREFIX}/include"
	export CXXFLAGS+=" -I${TERMUX_PREFIX}/include"
	mkdir -p netsurf/build/Linux-gtk3
	# Note: NETSURF_USE_DUKTAPE= disables javascript, because I couldn't figure out how to build
	# required the nsgenbind tool so that it can be executed on the *host* (it is used during the build process only)
	make PREFIX="${TERMUX_PREFIX}" NETSURF_GTK_MAJOR=3 NETSURF_USE_DUKTAPE=NO NETSURF_USE_LIBICONV_PLUG=NO toolchain=clang
}

termux_step_make() {
	# Nothing to do
	echo CC=$CC
}

termux_step_make_install () {
	echo CC=$CC
	export HOST=`$CC -dumpmachine`
	export BUILD=`$CC_FOR_BUILD -dumpmachine`
	export CFLAGS+=" -I${TERMUX_PREFIX}/include"
	export CPPFLAGS+=" -I${TERMUX_PREFIX}/include"
	export CXXFLAGS+=" -I${TERMUX_PREFIX}/include"
	make install PREFIX="${TERMUX_PREFIX}" NETSURF_GTK_MAJOR=3 NETSURF_USE_DUKTAPE=NO NETSURF_USE_LIBICONV_PLUG=NO toolchain=clang
	ln -sfr $TERMUX_PREFIX/bin/netsurf-gtk3 $TERMUX_PREFIX/bin/netsurf
}
