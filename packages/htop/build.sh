TERMUX_PKG_HOMEPAGE=https://htop.dev/
TERMUX_PKG_DESCRIPTION="Interactive process viewer for Linux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_SRCURL=https://github.com/htop-dev/htop/archive/${TERMUX_PKG_VERSION}/htop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a1dd174cc828521fe5fd0e052cff8c30aa50809cf80d3ce3a481c37d476ac54
# htop checks setlocale() return value for UTF-8 support, so use libandroid-support.
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BREAKS="htop-legacy"
TERMUX_PKG_CONFLICTS="htop-legacy"
TERMUX_PKG_REPLACES="htop-legacy"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
ac_cv_lib_ncursesw6_addnwstr=yes
LIBS=-landroid-support
"

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_create_debscripts() {
	cp -f $TERMUX_PKG_BUILDER_DIR/postinst ./
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" ./postinst
}
