TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-autoar
TERMUX_PKG_DESCRIPTION="gnome-autoar provides functions and widgets for GNOME applications"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.5"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-autoar/${TERMUX_PKG_VERSION%.*}/gnome-autoar-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=838c5306fc38bfaa2f23abe24262f4bf15771e3303fb5dcb74f5b9c7a615dabe
TERMUX_PKG_BUILD_DEPENDS="pkg-config, xorgproto, libxml2, libffi, libarchive"
TERMUX_PKG_DEPENDS="python, pygobject, gtk4, desktop-file-utils"
TERMUX_PKG_PYTHON_COMMON_DEPS="docutils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=disabled
-Dgtk_doc=false
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_meson
}
