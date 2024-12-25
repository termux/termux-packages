TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-cpugraph-plugin/start
TERMUX_PKG_DESCRIPTION="Graphical representation of the CPU load"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@knyipab"
TERMUX_PKG_VERSION="1.2.11"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-cpugraph-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-cpugraph-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=58aa31df1934afc2a352744754a730a3d796b1246e12c7a5e86f7b6a403ca20d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, xfce4-panel"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name) -landroid-glob"
}
