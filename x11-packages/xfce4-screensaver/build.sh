TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/screensaver/start
TERMUX_PKG_DESCRIPTION="Xfce Screensaver is a screen saver and locker that aims to have simple, sane, secure defaults and be well integrated with the desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
_MAJOR_VERSION=4.18
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screensaver/${_MAJOR_VERSION}/xfce4-screensaver-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e4fcd2c414d3a4215e9e86a55edd87e2545b15c961917f5d72cace35b76e2b98
TERMUX_PKG_DEPENDS="dbus, dbus-glib, garcon, gdk-pixbuf, glib, gtk3, libcairo, libwnck, libx11, libxext, libxfce4ui, libxfce4util, libxklavier, libxss, opengl, pango, termux-auth, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-locking --sysconfdir=$TERMUX_PREFIX/etc"
TERMUX_PKG_BUILD_IN_SRC=true
