TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/emersion/wlr-randr
TERMUX_PKG_DESCRIPTION="Utility to manage outputs of a Wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@JesusChapman <jesuschapmandev@outlook.com>"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/emersion/wlr-randr/-/archive/v${TERMUX_PKG_VERSION}/wlr-randr-v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=23382ce43bb7fe0fdca6b09daeec6b320018824c6cdbed5048ff36dc7fcd0fd5
TERMUX_PKG_DEPENDS="libwayland"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner"

termux_step_pre_configure(){
	termux_setup_wayland_cross_pkg_config_wrapper
}
