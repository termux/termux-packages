TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/screensaver/start
TERMUX_PKG_DESCRIPTION="Xfce Screensaver is a screen saver and locker that aims to have simple, sane, secure defaults and be well integrated with the desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="4.18.4"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screensaver/${TERMUX_PKG_VERSION%.*}/xfce4-screensaver-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=cf717d032d2d0555978c479299da992af6dc3363ae7e758af9515c7166eac170
TERMUX_PKG_DEPENDS="dbus, dbus-glib, garcon, gdk-pixbuf, glib, gtk3, libcairo, libwnck, libx11, libxext, libxfce4ui, libxfce4util, libxklavier, libxss, opengl, pango, termux-auth, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-locking --sysconfdir=$TERMUX_PREFIX/etc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
