TERMUX_PKG_HOMEPAGE=http://glx-dock.org/
TERMUX_PKG_DESCRIPTION="Cairo-Dock is a simple and avanzed dock for linux desktop."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Cairo-Dock/cairo-dock-core/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9a08efe15e257f18e33161b17c4bbab7c6889854a9fab96a69d6568f0e91475f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus-glib, gdk-pixbuf, glib, glu, gtk3, libcairo, libcurl, librsvg, libx11, libxcomposite, libxinerama, libxml2, libxrandr, libxrender, libxtst, opengl, pango, which"
TERMUX_PKG_BUILD_DEPENDS="valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFORCE_NOT_LIB64=yes
-DCMAKE_INSTALL_LIBDIR=lib
"
TERMUX_CMAKE_BUILD="Unix Makefiles"
