TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org/doc/dbus-python/
TERMUX_PKG_DESCRIPTION="Python bindings for D-Bus"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.0"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/dbus/dbus-python/-/archive/dbus-python-${TERMUX_PKG_VERSION}/dbus-python-dbus-python-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=69ec18db5dfbe535b7862f4d39f3b09a8ad8c6d8d54600ddd38e9b9c6df63ac5
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
