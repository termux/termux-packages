TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-screenshooter/start
TERMUX_PKG_DESCRIPTION="The Xfce4-screenshooter is an application that can be used to take snapshots of your desktop screen."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
_MAJOR_VERSION=1.10
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screenshooter/${_MAJOR_VERSION}/xfce4-screenshooter-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8ab7161e2d599e1f16891b9901d5849c2b9923b0a218b66d87179f224bc437d6
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libsm, libsoup3, libx11, libxext, libxfce4ui, libxfce4util, libxfixes, libxml2, pango, xfce4-panel, xfconf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_HELP2MAN=
"
