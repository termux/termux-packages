TERMUX_PKG_HOMEPAGE=https://github.com/xournalpp/xournalpp
TERMUX_PKG_DESCRIPTION="A hand note taking software"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.6"
TERMUX_PKG_SRCURL="https://github.com/xournalpp/xournalpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fc903596d796100d0ffb61f5e6b248f9042da1399fb3ce549dc73e986481ece5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, gtksourceview4, libandroid-execinfo, libc++, libcairo, librsvg, libsndfile, libx11, libxi, libxml2, libzip, pango, poppler, portaudio, qpdf, zlib"
TERMUX_PKG_REPLACES="xournal"
# Lua 5.4 would be a dependency if plugins were wanted
# Explicitly disable plugins for now to avoid prefix pollution
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_MAN=OFF
-DENABLE_PLUGINS=OFF
"

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-c++11-narrowing"
}
