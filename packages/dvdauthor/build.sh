TERMUX_PKG_HOMEPAGE=http://dvdauthor.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Generates a DVD-Video movie from a valid MPEG-2 stream"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/dvdauthor/dvdauthor-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3020a92de9f78eb36f48b6f22d5a001c47107826634a785a62dfcd080f612eb7
TERMUX_PKG_DEPENDS="freetype, fribidi, graphicsmagick, libdvdread, libpng, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_MAGICKCONFIG=GraphicsMagick-config
"
