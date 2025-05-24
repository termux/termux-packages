TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-taskmanager/start
TERMUX_PKG_DESCRIPTION="Easy to use task manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-taskmanager/${TERMUX_PKG_VERSION%.*}/xfce4-taskmanager-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=29bdc7840ab8b9025f6c0e456a83a31090d1c9fd9e26b359baa4a4010cfb0b90
TERMUX_PKG_DEPENDS="glib, gtk3, libcairo, libwnck, libx11, libxfce4ui, libxfce4util, libxmu, xfconf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwnck=enabled
-Dx11=enabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
