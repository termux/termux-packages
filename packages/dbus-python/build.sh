TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org/doc/dbus-python/
TERMUX_PKG_DESCRIPTION="Python bindings for D-Bus"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.1"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/dbus/dbus-python/-/archive/dbus-python-${TERMUX_PKG_VERSION}/dbus-python-dbus-python-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cab33626c4c2f69f9400eaa5a1b70b58f82c1220373258e45c3fe07a1958b544
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_DEPENDS="dbus, glib, python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpython=python
"

termux_step_pre_configure() {
	# Force using Meson
	rm -f configure
}
