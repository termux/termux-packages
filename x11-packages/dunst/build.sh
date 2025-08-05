TERMUX_PKG_HOMEPAGE=https://dunst-project.org/
TERMUX_PKG_DESCRIPTION="Lightweight and customizable notification daemon"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.0"
TERMUX_PKG_SRCURL=https://github.com/dunst-project/dunst/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a8a1813977ad5941488c66b914501703fc0f6e12e631dc18506ad617242e7a0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-wordexp, dbus, gdk-pixbuf, glib, harfbuzz, libcairo, libnotify, libx11, libxext, libxinerama, libxrandr, libxss, pango"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# TODO: Meson support is still considered experimental and may still have issues.
	mv meson.build{,.orig}

	LDFLAGS='-landroid-wordexp'
}
