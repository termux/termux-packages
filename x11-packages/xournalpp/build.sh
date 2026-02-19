TERMUX_PKG_HOMEPAGE=https://github.com/xournalpp/xournalpp
TERMUX_PKG_DESCRIPTION="A hand note taking software"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/xournalpp/xournalpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9c38cb9b9fedc307ac7cb2bba8a500858043c281fea12bcc9afd4914dfdcef6b
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
