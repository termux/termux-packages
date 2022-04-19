TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/screensaver/start
TERMUX_PKG_DESCRIPTION="Xfce Screensaver is a screen saver and locker that aims to have simple, sane, secure defaults and be well integrated with the desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=4.16.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screensaver/4.16/xfce4-screensaver-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6d4d143e3e62db679ce83ce7da97903390773ee0a8ceb05ff4c3dac36616268d
TERMUX_PKG_DEPENDS="atk, gtk3, garcon, libwnck, libxext, libxklavier, libxss, termux-auth, libcairo, dbus-glib, pango, libxfce4ui, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-locking --sysconfdir=$TERMUX_PREFIX/etc"
TERMUX_PKG_BUILD_IN_SRC=true
