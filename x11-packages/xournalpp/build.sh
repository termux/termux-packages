TERMUX_PKG_HOMEPAGE=https://github.com/xournalpp/xournalpp
TERMUX_PKG_DESCRIPTION="A hand note taking software"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.8"
TERMUX_PKG_SRCURL=https://github.com/xournalpp/xournalpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f42d81e9509d4bd2d4c2cb2c54049c8518381aa9500c0671febd6c518010e0a7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, gtksourceview4, libandroid-execinfo, libc++, libcairo, librsvg, libsndfile, libx11, libxi, libxml2, libzip, pango, poppler, portaudio, zlib"
TERMUX_PKG_REPLACES="xournal"
# Lua 5.4 would be a dependency if plugins were wanted
# Explicitly disable plugins for now to avoid prefix pollution
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHELP2MAN=NO
-DENABLE_PLUGINS=OFF
"
