TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/libgxps
TERMUX_PKG_DESCRIPTION="handling and rendering XPS documents"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.3
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libgxps/${_MAJOR_VERSION}/libgxps-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6d27867256a35ccf9b69253eb2a88a32baca3b97d5f4ef7f82e3667fa435251c
TERMUX_PKG_DEPENDS="freetype, glib, libarchive, libcairo, libgxps, libjpeg-turbo, libpng, libtiff, littlecms"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-test=false
-Denable-man=true
-Ddisable-introspection=false
"

termux_step_pre_configure() {
	termux_setup_gir
}
