TERMUX_PKG_HOMEPAGE=https://www.giuspen.net/cherrytree/
TERMUX_PKG_DESCRIPTION="A hierarchical note taking application"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.99.55
TERMUX_PKG_SRCURL=https://github.com/giuspen/cherrytree/releases/download/${TERMUX_PKG_VERSION}/cherrytree_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7daa4358463eb41c133d9b4b742df18f68f47fa5bf398fc2e0801fc4c8381e84
TERMUX_PKG_DEPENDS="fribidi, glib, gspell, gtk3, gtkmm3, gtksourceview3, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libcurl, libglibmm-2.4, libgtksourceviewmm-3.0, libpangomm-1.4, libsigc++-2.0, libsqlite, libuchardet, libvte, libxml++-2.6, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="fmt, libspdlog"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DUSE_NLS=OFF
-DUSE_SHARED_FMT_SPDLOG=ON
"
