TERMUX_PKG_HOMEPAGE=https://dunst-project.org/
TERMUX_PKG_DESCRIPTION="Lightweight and customizable notification daemon"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.0"
TERMUX_PKG_SRCURL=https://github.com/dunst-project/dunst/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=31c0eb749ca83dab7f5af33beb951c9f9a8451263fcee6cbcf8ba3dedbf2e1f1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-wordexp, dbus, gdk-pixbuf, glib, libcairo, libnotify, libx11, libxext, libxinerama, libxrandr, libxss, pango"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS='-landroid-wordexp'
}
