TERMUX_PKG_HOMEPAGE=https://gtkwave.github.io/gtkwave/
TERMUX_PKG_DESCRIPTION="A wave viewer which reads LXT, LXT2, VZT, GHW and VCD/EVCD files"
TERMUX_PKG_LICENSE="GPL-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:3.3.116"
TERMUX_PKG_SRCURL=https://github.com/gtkwave/gtkwave/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=b178398da32f8e1958db74057fec278fe0fcc3400485f20ded3ab2330c58f598
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+'
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk2, gtk3, libandroid-shmem, libbz2, libc++, liblzma, pango, zlib"
TERMUX_PKG_RECOMMENDS="desktop-file-utils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tcl --disable-mime-update"

termux_step_post_get_source() {
	rm -rf "$TERMUX_PKG_SRCDIR/gtkwave3"
	mv "$TERMUX_PKG_SRCDIR/gtkwave3-gtk3" "$TERMUX_PKG_TMPDIR/gtkwave3-gtk3"
	mv "$TERMUX_PKG_TMPDIR/gtkwave3-gtk3"/* "$TERMUX_PKG_SRCDIR"
	rm -rf "$TERMUX_PKG_TMPDIR/gtkwave3-gtk3"
}
