TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/xournal/
TERMUX_PKG_DESCRIPTION="Notetaking and sketching application"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.8.2016
TERMUX_PKG_REVISION=33
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/xournal/xournal-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b25898dbd7a149507f37a16769202d69fbebd4a000d766923bbd32c5c7462826
TERMUX_PKG_DEPENDS="atk, desktop-file-utils, fontconfig, freetype, glib, gtk2, hicolor-icon-theme, libandroid-shmem, libart-lgpl, libcairo, libgnomecanvas, pango, poppler, libx11, shared-mime-info, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
	export LIBS="-Wl,--no-as-needed -landroid-shmem"
}
