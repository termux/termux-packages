TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-cpugraph-plugin/start
TERMUX_PKG_DESCRIPTION="Graphical representation of the CPU load"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@knyipab"
TERMUX_PKG_VERSION="1.2.10"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-cpugraph-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-cpugraph-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=37792dd052691712195658169b95fb6583f924485ce7a467b33d01e08775d915
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, xfce4-panel"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name) -landroid-glob"
}
