TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start
TERMUX_PKG_DESCRIPTION="A modern, docklike, minimalist taskbar for XFCE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_SRCURL=https://gitlab.xfce.org/panel-plugins/xfce4-docklike-plugin/-/archive/xfce4-docklike-plugin-${TERMUX_PKG_VERSION}/xfce4-docklike-plugin-xfce4-docklike-plugin-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6270522d07388b8c8a5e64e73592f714106a4e14927b8c98db3f1dad6d73e5e1
TERMUX_PKG_DEPENDS="xfce4-panel, libxfce4ui, libwnck, gtk3, glib, exo, ndk-sysroot"
TERMUX_PKG_BUILD_DEPENDS="intltool, xfce4-dev-tools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	NOCONFIGURE=1 ./autogen.sh
	
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
