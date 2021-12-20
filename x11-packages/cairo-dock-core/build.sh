TERMUX_PKG_HOMEPAGE=http://glx-dock.org/
TERMUX_PKG_DESCRIPTION="Cairo-Dock is a simple and avanzed dock for linux desktop."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <jesuspixel5@gmail.com>"
TERMUX_PKG_VERSION=3.4.1
_COMMIT=6c569e67a2a366e7634224a0133ede51755629cb
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/Cairo-Dock/cairo-dock-core/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=e59e99147ce9c901b46d4b56b88bd53aeda34292b86fd9fbf2c55d158153f2ec
TERMUX_PKG_DEPENDS="atk, dbus-glib, glib, gtk3, pango, libcairo, libx11, xsltproc, libcurl, gdk-pixbuf, harfbuzz, mesa, glu, librsvg, libxcomposite, libwayland, libwayland-protocols, libxinerama, libxrandr, libxrender, libxtst, libxml2"
TERMUX_PKG_BUILD_DEPENDS="valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DFORCE_NOT_LIB64=yes"
TERMUX_CMAKE_BUILD="Unix Makefiles"

