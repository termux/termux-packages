TERMUX_PKG_HOMEPAGE=https://xkbcommon.org/
TERMUX_PKG_DESCRIPTION="Keymap handling library for toolkits and window systems"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.2"
TERMUX_PKG_SRCURL=https://github.com/xkbcommon/libxkbcommon/archive/xkbcommon-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8d68a8b45796f34f7cace357b9f89b8c92b158557274fef5889b03648b55fe59
TERMUX_PKG_DEPENDS="libxcb, libxml2, libwayland, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, xorg-util-macros"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='(?<=-).+'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-docs=false
-Denable-wayland=true
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_wayland_cross_pkg_config_wrapper
}
