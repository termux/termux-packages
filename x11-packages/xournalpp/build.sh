TERMUX_PKG_HOMEPAGE=https://github.com/xournalpp/xournalpp
TERMUX_PKG_DESCRIPTION="A hand note taking software"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/xournalpp/xournalpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5021c7a8f53687edb3a759e079c54d23d5918d83f8d1f5fcd08a1da2ce81bd8b
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libandroid-execinfo, libc++, libcairo, librsvg, libsndfile, libx11, libxi, libxml2, libzip, pango, poppler, portaudio, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHELP2MAN=NO
"
