TERMUX_PKG_HOMEPAGE=https://www.giuspen.net/cherrytree/
TERMUX_PKG_DESCRIPTION="A hierarchical note taking application"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://github.com/giuspen/cherrytree/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8d4e66b3c16e2362a4e98146e0bfe788803d9d54282392d44a917a3c74e9d32e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fmt, fribidi, glib, gspell, gtk3, gtkmm3, gtksourceview4, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libcurl, libglibmm-2.4, libpangomm-1.4, libsigc++-2.0, libsqlite, libuchardet, libvte, libxml++-2.6, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="libspdlog"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DUSE_NLS=OFF
-DUSE_SHARED_FMT_SPDLOG=ON
"
