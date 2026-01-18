TERMUX_PKG_HOMEPAGE=https://github.com/dracula/gtk.git
TERMUX_PKG_DESCRIPTION="Dark theme for GTK"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.0+p20260113"
_COMMIT=1892c797926184066b9f740f5a7c3ab2772edc40
TERMUX_PKG_SRCURL=https://github.com/dracula/gtk/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=69006c52b6b75e8b19d67d52c665d606ae80fdcdd2020dbc8c8b5f88347e6bed
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/share/themes/Dracula"
	cp -rf * "$TERMUX_PREFIX/share/themes/Dracula"
}
