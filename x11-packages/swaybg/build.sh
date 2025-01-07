TERMUX_PKG_HOMEPAGE=https://github.com/swaywm/swaybg
TERMUX_PKG_DESCRIPTION="Wallpaper tool for Wayland compositors"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.1"
TERMUX_PKG_SRCURL=https://github.com/swaywm/swaybg/releases/download/v${TERMUX_PKG_VERSION}/swaybg-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6af1fdf0e57b1cc5345febed786b761fea0e170943a82639f94cfaed7df84f8f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, libcairo, libwayland"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgdk-pixbuf=enabled
-Dman-pages=enabled
-Dwerror=false
"
