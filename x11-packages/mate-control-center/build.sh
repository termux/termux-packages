TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Utilities to configure the MATE desktop"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.1"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-control-center/releases/download/v$TERMUX_PKG_VERSION/mate-control-center-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=cb1d81397dc44503d5c4cf66c7911ede875aff3194da19e12e41bee8eb207f59
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dconf, mate-menus, mate-settings-daemon, marco, libgtop, libxss, mate-desktop, gettext, mate-panel, libcanberra, libayatana-appindicator"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, glib, mate-common"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
--disable-update-mimedb
--disable-systemd
"

termux_step_pre_configure() {
	autoreconf -fi
}
