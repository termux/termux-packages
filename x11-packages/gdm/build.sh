TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gdm
# XXX: This package actually doesn't WORK on Termux, because Android doesn't have Virtual Terminal.
# XXX: It is used by `gnome-terminal` and other GNOME apps through GObject-Introspection.
TERMUX_PKG_DESCRIPTION="GNOME display manager"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.0"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gdm/${TERMUX_PKG_VERSION%%.*}/gdm-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=1bc06daff093ec7b5e37ecb4f92e5da3474a1b1ba076edb9151ee967d1c30adf
TERMUX_PKG_DEPENDS="accountsservice, consolekit2, glib, gnome-desktop3, gtk3, json-glib, libice, libsm, libx11"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
# Should be bumped with gnome-shell
TERMUX_PKG_AUTO_UPDATE=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlog-dir=$TERMUX_PREFIX/var/log/gdm
-Ddummy-pam=true
-Dlogind-provider=dummy
-Dsystemd-journal=false
-Dsystemdsystemunitdir=no
-Dsystemduserunitdir=no
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
