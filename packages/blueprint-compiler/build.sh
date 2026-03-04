TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/blueprint-compiler/
TERMUX_PKG_DESCRIPTION="Markup language for GTK user interfaces"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/blueprint-compiler/${TERMUX_PKG_VERSION%.*}/blueprint-compiler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ec786d66f583e8296c845f1f82834d27b369f39d55a6380b34880493e22db382
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gobject-introspection, python, pygobject"

termux_step_pre_configure() {
	termux_setup_python_pip
}
