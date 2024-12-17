TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/tumbler/start
TERMUX_PKG_DESCRIPTION="Tumbler is a D-Bus service for applications to request thumbnails for various URI schemes and MIME type"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/tumbler/${TERMUX_PKG_VERSION%.*}/tumbler-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=74b1647d55926547e98bfac70838ff63c5a84299a5e10c81c38d1fab90e25880
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, gdk-pixbuf, glib, libcurl, libjpeg-turbo, libpng, libxfce4util"
TERMUX_PKG_RM_AFTER_INSTALL="lib/systemd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--enable-gtk-doc-html=no
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
