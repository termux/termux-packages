TERMUX_PKG_HOMEPAGE=https://github.com/lgi-devs/lgi
TERMUX_PKG_DESCRIPTION="Dynamic Lua binding to GObject libraries using GObject-Introspection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.2+p20260728
_COMMIT=7a2276f9657a50ee548a636f2e646f96ec748bbd
TERMUX_PKG_SRCURL=https://github.com/lgi-devs/lgi/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=438fd9efcbfafa796dea7ea38b07177a13023e3ef4487465bd9e13a7467a0ae7
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libcairo, libffi, lua54"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-Dtests=false
	-Dlua-pc=lua54
"

termux_step_pre_configure() {
	termux_setup_cmake
}
