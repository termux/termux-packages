TERMUX_PKG_HOMEPAGE=https://libmatekbd.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="libmatekbd is a fork of libgnomekbd"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.25.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/libmatekbd/releases/download/v$TERMUX_PKG_VERSION/libmatekbd-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=0e0580370f29d867a11291805b2d39a0cd1951f84cda3f91cb9611f246a8e305
TERMUX_PKG_DEPENDS="glib, gtk3, libxklavier"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
LIBXKLAVIER=${TERMUX_PREFIX}/lib/libxklavier.so
--enable-introspection=yes
"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

termux_step_pre_configure() {
	termux_setup_gir

	export GLIB_COMPILE_RESOURCES="glib-compile-resources"
	export GLIB_COMPILE_SCHEMAS="glib-compile-schemas"
}
