TERMUX_PKG_HOMEPAGE=https://github.com/lgi-devs/lgi
TERMUX_PKG_DESCRIPTION="Dynamic Lua binding to GObject libraries using GObject-Introspection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.2+p20251219
_COMMIT=a1308b23b07a787d21fad86157b0b60eb3079f64
TERMUX_PKG_SRCURL=https://github.com/lgi-devs/lgi/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=fda70ea777c6add0511f847dcf6985a767c29fc55fb688fdf748ab415bc29dad
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libcairo, libffi, lua54"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-Dtests=false
	-Dlua-pc=lua54
"

termux_step_pre_configure() {
	termux_setup_cmake
}
