TERMUX_PKG_HOMEPAGE=https://www.giuspen.net/cherrytree/
TERMUX_PKG_DESCRIPTION="A hierarchical note taking application"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.99.56
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/giuspen/cherrytree/releases/download/${TERMUX_PKG_VERSION}/cherrytree_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d98717b0b04bc989c86b50d33d4d5a31e8cb5750d4f913f9390373d43e542bbf
TERMUX_PKG_DEPENDS="fribidi, glib, gspell, gtk3, gtkmm3, gtksourceview3, libatkmm-1.6, libc++, libcairo, libcairomm-1.0, libcurl, libglibmm-2.4, libgtksourceviewmm-3.0, libpangomm-1.4, libsigc++-2.0, libsqlite, libuchardet, libvte, libxml++-2.6, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="fmt, libspdlog"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTING=OFF
-DUSE_NLS=OFF
-DUSE_SHARED_FMT_SPDLOG=ON
"
