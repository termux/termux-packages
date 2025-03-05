TERMUX_PKG_HOMEPAGE=https://dunst-project.org/
TERMUX_PKG_DESCRIPTION="Lightweight and customizable notification daemon"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.2"
TERMUX_PKG_SRCURL=https://github.com/dunst-project/dunst/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8f7664bd4e6083e9604e282145fe5b8dee7655fa0b099a5b682a2549e1f33d32
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-wordexp, dbus, gdk-pixbuf, glib, harfbuzz, libcairo, libnotify, libx11, libxext, libxinerama, libxrandr, libxss, pango"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS='-landroid-wordexp'
}
