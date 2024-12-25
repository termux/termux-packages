TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-calculator-plugin/start
TERMUX_PKG_DESCRIPTION="Simple command line based calculator for the Xfce panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.3"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-calculator-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-calculator-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3feb5f56092ceef2858c3c1bd443317d4caf289a6409f9db506f49088e19a2e8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, zlib"
TERMUX_PKG_BUILD_DEPENDS="xfce4-dev-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"
