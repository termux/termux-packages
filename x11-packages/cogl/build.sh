TERMUX_PKG_HOMEPAGE=https://developer-old.gnome.org/cogl/
TERMUX_PKG_DESCRIPTION="A small open source library for using 3D graphics hardware for rendering"
TERMUX_PKG_LICENSE="MIT, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.22
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/cogl/${_MAJOR_VERSION}/cogl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a805b2b019184710ff53d0496f9f0ce6dcca420c141a0f4f6fcc02131581d759
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, harfbuzz, libandroid-shmem, libcairo, libx11, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, opengl, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
with_gl_libname=libGL.so
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir

	LDFLAGS+=" -landroid-shmem"

	export GLIB_GENMARSHAL=glib-genmarshal
	export GOBJECT_QUERY=gobject-query
	export GLIB_MKENUMS=glib-mkenums
	export GLIB_COMPILE_RESOURCES=glib-compile-resources
}
