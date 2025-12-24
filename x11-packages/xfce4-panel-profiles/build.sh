TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-panel-profiles/start
TERMUX_PKG_DESCRIPTION="A simple application to manage Xfce panel layouts."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-panel-profiles/${TERMUX_PKG_VERSION%.*}/xfce4-panel-profiles-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0126373a03778bb4894afa151de28d36bfc563ddab96d3bd7c63962350d34ba2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gtk3, libxfce4ui, libxfce4util, pygobject, python, python-pip, xfce4-panel"
TERMUX_PKG_PYTHON_TARGET_DEPS="psutil"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	# from configure
	sed -e s,@prefix@,$TERMUX_PREFIX, Makefile.in.in > Makefile.in
	sed \
		-e s,@appname@,xfce4-panel-profiles,g \
		-e s,@version@,$TERMUX_PKG_VERSION,g \
		-e s,@mandir@,$TERMUX_PREFIX/share/man,g \
		-e s,@docdir@,$TERMUX_PREFIX/share/doc/xfce4-panel-profiles,g \
		-e s,@python@,$TERMUX_PREFIX/bin/python,g \
		Makefile.in > Makefile
	sed \
		-e s,@VERSION@,$TERMUX_PKG_VERSION,g \
		-e s,@COPYRIGHT_YEAR@,2025,g \
	xfce4-panel-profiles.1.in > xfce4-panel-profiles.1
}
