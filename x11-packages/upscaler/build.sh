TERMUX_PKG_HOMEPAGE="https://gitlab.gnome.org/World/Upscaler"
TERMUX_PKG_DESCRIPTION="Upscale and enhance images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.3"
TERMUX_PKG_SRCURL="https://gitlab.gnome.org/World/Upscaler/-/archive/${TERMUX_PKG_VERSION}/Upscaler-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="3c295dddcf47c0abfb34f1b96c05273d61b11d7416501ace85b9a6a9d1511cf6"
TERMUX_PKG_DEPENDS="libadwaita, pygobject, python-pillow, upscayl-ncnn, python, python-pip, gtk4, pango, glib"
TERMUX_PKG_PYTHON_RUNTIME_DEPS="vulkan"
TERMUX_PKG_BUILD_DEPENDS="blueprint-compiler, glib-cross"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_meson
	termux_setup_bpc
	termux_setup_glib_cross_pkg_config_wrapper
}
