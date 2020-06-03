TERMUX_PKG_HOMEPAGE=http://www.netsurf-browser.org/
TERMUX_PKG_DESCRIPTION="NetSurf is a free, open source web browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=3.10
TERMUX_PKG_SRCURL=http://download.netsurf-browser.org/netsurf/releases/source-full/netsurf-all-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=495adf6b6614ce36fca6c605f7c321f9cb4a3df838043158122678ce2b3325b7
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, libjpeg-turbo, libpng, gtk3, openssl, libcurl, libiconv, libwebp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	export HOST=$($CC -dumpmachine)
	export BUILD=$($CC_FOR_BUILD -dumpmachine)
	export CFLAGS+=" $CPPFLAGS"
	export CXXFLAGS+=" $CPPFLAGS"
	mkdir -p netsurf/build/Linux-gtk3

	# Note: NETSURF_USE_DUKTAPE= disables javascript, because I couldn't figure out how to build
	# required the nsgenbind tool so that it can be executed on the *host* (it is used during the build process only)
	make PREFIX="${TERMUX_PREFIX}" NETSURF_GTK_MAJOR=3 NETSURF_USE_DUKTAPE=NO NETSURF_USE_LIBICONV_PLUG=NO toolchain=clang
}

termux_step_make_install() {
	make install PREFIX="${TERMUX_PREFIX}" NETSURF_GTK_MAJOR=3 NETSURF_USE_DUKTAPE=NO NETSURF_USE_LIBICONV_PLUG=NO toolchain=clang
}
