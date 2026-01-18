TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org/doc/dbus-python/
TERMUX_PKG_DESCRIPTION="Python bindings for D-Bus"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/dbus/dbus-python/-/archive/dbus-python-${TERMUX_PKG_VERSION}/dbus-python-dbus-python-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da4ee9bbb9eb901d463a7cc9f99dfdbe6c751c8b48b29b78d378985a3c9656ad
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
