TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-session
TERMUX_PKG_DESCRIPTION="The Cinnamon session manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.1"
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-session/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b5ad4f70698a56cad3f0fcb75493d21b633073e80b82a51796339b9bbff85a1b
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="glib, libcanberra, gtk3, pango, libx11, libsm, libice, libxext, libxau, libxcomposite, cinnamon-desktop, opengl, dbus-python, keybinder, xapp"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_PYTHON_TARGET_DEPS="psutil, pyinotify, pyinotify-elephant-fork"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dxtrans=false
-Dfake-consolekit=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		echo "Installing dependencies through pip..."
		pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
