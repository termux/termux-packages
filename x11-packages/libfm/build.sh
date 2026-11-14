TERMUX_PKG_HOMEPAGE=https://github.com/lxde/libfm
TERMUX_PKG_DESCRIPTION="Library for file management"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=https://github.com/lxde/libfm/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1dff59162eb1ca5d1a6b945de4d0bdf2256a5264f54c9225b8599adce45dcb05
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libandroid-support, libcairo, libexif, libffi, menu-cache, pango, pcre"
TERMUX_PKG_BUILD_DEPENDS="valac"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gtk=3"

# Avoid conflict with libfm-extra-static which already ships these
TERMUX_PKG_RM_AFTER_INSTALL="
lib/libfm-extra.a
lib/libfm-extra.la
"

TERMUX_PKG_CONFLICTS="libfm-extra"
TERMUX_PKG_REPLACES="libfm-extra"
TERMUX_PKG_PROVIDES="libfm-extra (= $TERMUX_PKG_VERSION)"

termux_step_pre_configure() {
	./autogen.sh
}
