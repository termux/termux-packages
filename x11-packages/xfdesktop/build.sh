TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="A desktop manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.16.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://gitlab.xfce.org/xfce/xfdesktop/-/archive/xfdesktop-${TERMUX_PKG_VERSION}/xfdesktop-xfdesktop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9835d1b532c3a4db010b22b35c6d0870c3037d43deecf58274125e906452268a
TERMUX_PKG_DEPENDS="exo, garcon, hicolor-icon-theme, libwnck, libxfce4ui, startup-notification, thunar"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-notifications --enable-maintainer-mode"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
