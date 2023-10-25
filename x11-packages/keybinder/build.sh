TERMUX_PKG_HOMEPAGE=https://github.com/kupferlauncher/keybinder
TERMUX_PKG_DESCRIPTION="A library for registering global keyboard shortcuts"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/kupferlauncher/keybinder/releases/download/keybinder-3.0-v${TERMUX_PKG_VERSION}/keybinder-3.0-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e6e3de4e1f3b201814a956ab8f16dfc8a262db1937ff1eee4d855365398c6020
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libx11, libxext, libxrender, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection
"

termux_step_pre_configure() {
	termux_setup_gir
}
