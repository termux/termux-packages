TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-genmon-plugin
TERMUX_PKG_DESCRIPTION="Display cyclically run script or program output onto the panel"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1.1
TERMUX_PKG_SRCURL=https://gitlab.xfce.org/panel-plugins/xfce4-genmon-plugin/-/archive/xfce4-genmon-plugin-${TERMUX_PKG_VERSION}/xfce4-genmon-plugin-xfce4-genmon-plugin-${TERMUX_PKG_VERSION}.tar
TERMUX_PKG_SHA256=727bb05022c5f25e83977311a1051dd3d211964c7d464fa14312e681198bc9cd
TERMUX_PKG_DEPENDS="hicolor-icon-theme, xfce4-panel"
TERMUX_PKG_BUILD_DEPENDS="intltool"


termux_step_pre_configure () {
	NOCONFIGURE=1 ./autogen.sh
}
