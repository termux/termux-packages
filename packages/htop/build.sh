TERMUX_PKG_HOMEPAGE=https://htop.dev/
TERMUX_PKG_DESCRIPTION="Interactive process viewer for Linux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_SRCURL=https://github.com/htop-dev/htop/archive/${TERMUX_PKG_VERSION}/htop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a45cd93b393eaa5804a7e490d58d0940b1c74bb24ecff2ae7b5c49e7a3c1198
# htop checks setlocale() return value for UTF-8 support, so use libandroid-support.
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BREAKS="htop-legacy"
TERMUX_PKG_CONFLICTS="htop-legacy"
TERMUX_PKG_REPLACES="htop-legacy"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
ac_cv_lib_ncursesw6_addnwstr=yes
LIBS=-landroid-support
"

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/var/htop"
	cp -a "$TERMUX_PKG_BUILDER_DIR/procstat" "$TERMUX_PREFIX/var/htop/stat"
}
