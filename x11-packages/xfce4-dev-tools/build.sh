TERMUX_PKG_HOMEPAGE=https://gitlab.xfce.org/xfce/xfce4-dev-tools
TERMUX_PKG_DESCRIPTION="A collection of tools and macros for Xfce developers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-dev-tools/${TERMUX_PKG_VERSION%.*}/xfce4-dev-tools-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1fba39a08a0ecc771eaa3a3b6e4272a4f0b9e7c67d0f66e780cd6090cd4466aa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_MESON=meson
"
