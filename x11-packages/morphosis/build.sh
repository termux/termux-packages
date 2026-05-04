TERMUX_PKG_HOMEPAGE="https://gitlab.gnome.org/World/morphosis"
TERMUX_PKG_DESCRIPTION="Convert your documents"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="50.0"
TERMUX_PKG_SRCURL="https://gitlab.gnome.org/World/morphosis/-/archive/${TERMUX_PKG_VERSION}/morphosis-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="336e4c680205651e2376357f118c5cbdaa4006c22d9a886717f7eb3c1bac5c3c"
TERMUX_PKG_DEPENDS="gtk4, libadwaita, pandoc, pygobject, python, python-pip"
TERMUX_PKG_BUILD_DEPENDS="blueprint-compiler, glib-cross"
TERMUX_PKG_PYTHON_RUNTIME_DEPS="weasyprint"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprofile=release
"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686" # pandoc doesn't support 32bit

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_bpc
	echo "Applying fix-python-install-dir.diff"
	sed "s%@PYTHON_VERSION@%$TERMUX_PYTHON_VERSION%g" \
		$TERMUX_PKG_BUILDER_DIR/fix-python-install-dir.diff | patch --silent -p1
}
