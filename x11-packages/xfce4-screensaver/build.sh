TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/screensaver/start
TERMUX_PKG_DESCRIPTION="Xfce Screensaver is a screen saver and locker that aims to have simple, sane, secure defaults and be well integrated with the desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
_MAJOR_VERSION=4.16
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screensaver/${_MAJOR_VERSION}/xfce4-screensaver-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6d4d143e3e62db679ce83ce7da97903390773ee0a8ceb05ff4c3dac36616268d
TERMUX_PKG_DEPENDS="dbus, dbus-glib, garcon, gdk-pixbuf, glib, gtk3, libcairo, libwnck, libx11, libxext, libxfce4ui, libxklavier, libxss, opengl, pango, termux-auth, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-locking --sysconfdir=$TERMUX_PREFIX/etc"
TERMUX_PKG_BUILD_IN_SRC=true
