TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-mailwatch-plugin/start
TERMUX_PKG_DESCRIPTION="Xfce4 Mailwatch Plugin is a multi-protocol, multi-mailbox mail watcher for the Xfce4 panel."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-mailwatch-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-mailwatch-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c4783f1533891cd2e0c34066da859864dce45a23caa6015b58cb9fa9d65a7e44
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libgnutls, libxfce4ui, libxfce4util, pango, xfce4-panel, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
--enable-ssl
--enable-ipv6
"
