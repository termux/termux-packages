TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-places-plugin/start
TERMUX_PKG_DESCRIPTION="This plugin brings much of the functionality of GNOME Places menu to Xfce"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.8.4"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-places-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-places-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ba766a5d31580fad043fbd1fd66b811cbda706229473d24a734a590d49ef710e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libnotify, libsm, libx11, libxfce4ui, libxfce4util, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"
