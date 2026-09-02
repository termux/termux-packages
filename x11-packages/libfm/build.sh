TERMUX_PKG_HOMEPAGE=https://github.com/lxde/pcmanfm
TERMUX_PKG_DESCRIPTION="Library for file management"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL="https://github.com/lxde/libfm/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a5042630304cf8e5d8cff9d565c6bd546f228b48c960153ed366a34e87cad1e5
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libandroid-support, libcairo, libexif, libffi, menu-cache, pango, pcre2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_CONFLICTS="libfm-extra"
TERMUX_PKG_REPLACES="libfm-extra"
TERMUX_PKG_PROVIDES="libfm-extra (= $TERMUX_PKG_VERSION)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gtk=3"
