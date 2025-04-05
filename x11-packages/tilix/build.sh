TERMUX_PKG_HOMEPAGE=https://gnunn1.github.io/tilix-web
TERMUX_PKG_DESCRIPTION="A tiling terminal emulator for Linux using GTK+ 3"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_VERSION=1.9.6
TERMUX_PKG_SRCURL=https://github.com/gnunn1/tilix/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=be389d199a6796bd871fc662f8a37606a1f84e5429f24e912d116f16c5f0a183
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dconf, gdk-pixbuf, glib, gsettings-desktop-schemas, gtk3, libcairo, libsecret, libvte, libx11, pango"
TERMUX_PKG_BUILD_DEPENDS="ldc, binutils-cross"

termux_step_configure() {
	termux_setup_ldc
}

termux_step_make_install() {
	bash install.sh $TERMUX_PREFIX
}
