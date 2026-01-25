TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Image viewer for MATE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/eom/releases/download/v$TERMUX_PKG_VERSION/eom-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=9a01cab2995a1a8c7258c865eae5f182ed4730c44672afdc3a07e423edd53abc
# version 1.28.1 has a build failure not only in Termux, but also the same error in upstream's own CI;
# wait for them to fix it
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="dbus-glib, gobject-introspection, gettext, librsvg, littlecms, libexif, libjpeg-turbo, mate-desktop, libpeas"
TERMUX_PKG_RECOMMENDS="webp-pixbuf-loader"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, glib, mate-common"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--localstatedir=$TERMUX_PREFIX/var
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
