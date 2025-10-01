TERMUX_PKG_HOMEPAGE=https://github.com/Cairo-Dock/cairo-dock-core
TERMUX_PKG_DESCRIPTION="Cairo-Dock is a simple and avanzed dock for linux desktop."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.6.0"
TERMUX_PKG_SRCURL=https://github.com/Cairo-Dock/cairo-dock-core/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b7c5d08dbd61d4f18c463a0eba4b8a0ff5c2830225c56b7cffe9e84d01af2e3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus-glib, gdk-pixbuf, glib, glu, gtk3, libcairo, libcurl, librsvg, libx11, libxcomposite, libxinerama, libxml2, libxrandr, libxrender, libxtst, opengl, pango, which"
TERMUX_PKG_BUILD_DEPENDS="valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFORCE_NOT_LIB64=yes
-DCMAKE_INSTALL_LIBDIR=lib
"
