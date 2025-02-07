TERMUX_PKG_HOMEPAGE=https://www.giuspen.net/cherrytree/
TERMUX_PKG_DESCRIPTION="A hierarchical note taking application"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL=https://github.com/giuspen/cherrytree/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0472a52cfd052c2349137722421c364201d0706b5345425d14b51c355ed2b89d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fmt, fribidi, glib, gspell, gtk3, gtkmm3, gtksourceview4, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libcurl, libglibmm-2.4, libpangomm-1.4, libsigc++-2.0, libsqlite, libuchardet, libvte, libxml++-2.6, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="libspdlog"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DUSE_NLS=OFF
-DUSE_SHARED_FMT_SPDLOG=ON
"
