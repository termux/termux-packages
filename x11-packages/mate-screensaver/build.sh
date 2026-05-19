TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Screensaver for MATE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.1"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-screensaver/releases/download/v$TERMUX_PKG_VERSION/mate-screensaver-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=a20d49bcf4e577287c0cd78596158923c729d6370b6da19a98ac655b029cce36
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="mate-panel, libmatekbd, gettext, libnotify, libxss, mate-desktop, mate-menus, mate-session-manager"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, glib, mate-common"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--with-mit-ext
--with-libnotify
--disable-locking
--without-console-kit
"
