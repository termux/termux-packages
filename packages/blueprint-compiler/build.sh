TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/blueprint-compiler/
TERMUX_PKG_DESCRIPTION="Markup language for GTK user interfaces"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/blueprint-compiler/${TERMUX_PKG_VERSION%.*}/blueprint-compiler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=231d72efbac931c235ac3e022fe94982095c20d88721d9a8dcf60152f2017e07
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gobject-introspection, python, pygobject"

termux_step_pre_configure() {
	termux_setup_python_pip
}
