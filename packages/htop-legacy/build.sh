TERMUX_PKG_HOMEPAGE=https://hisham.hm/htop/
TERMUX_PKG_DESCRIPTION="Interactive process viewer for Linux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# DO NOT UPDATE
TERMUX_PKG_VERSION=1:2.2.0
TERMUX_PKG_SRCURL=https://github.com/htop-dev/htop/archive/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=fb23275090ee5fb19266384c39c69519c8b3844b8f6444730094949c621197c0
# htop checks setlocale() return value for UTF-8 support, so use libandroid-support.
TERMUX_PKG_DEPENDS="ncurses, libandroid-support"
TERMUX_PKG_CONFLICTS="htop"
TERMUX_PKG_REPLACES="htop"
TERMUX_PKG_PROVIDES="htop"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_ncursesw6_addnwstr=yes
LIBS=-landroid-support
"

termux_step_pre_configure() {
	./autogen.sh
}
