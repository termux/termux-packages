TERMUX_PKG_HOMEPAGE=https://gnome.pages.gitlab.gnome.org/blueprint-compiler/
TERMUX_PKG_DESCRIPTION="Markup language for GTK user interfaces"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.4"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/blueprint-compiler/${TERMUX_PKG_VERSION%.*}/blueprint-compiler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1f1ecc84bcd698902d422f7de83d39229a209dd3016f6d2c3b0ed0ab123f6891
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gobject-introspection, python, pygobject"

termux_step_pre_configure() {
	termux_setup_python_pip
}
