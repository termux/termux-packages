TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-screenshooter/start
TERMUX_PKG_DESCRIPTION="The Xfce4-screenshooter is an application that can be used to take snapshots of your desktop screen."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.10.6"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screenshooter/${TERMUX_PKG_VERSION%.*}/xfce4-screenshooter-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=992066cfecfb44a68681340bfd55d524d40410aac3da6ef25c6c6cb2150a5965
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libsm, libsoup3, libx11, libxext, libxfce4ui, libxfce4util, libxfixes, libxml2, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_HELP2MAN=
"
