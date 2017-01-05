TERMUX_PKG_HOMEPAGE=http://www.gpsbabel.org/
TERMUX_PKG_DESCRIPTION="GPS file conversion plus transfer to/from GPS units"
TERMUX_PKG_VERSION=1.4.4
TERMUX_PKG_SRCURL=https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_4_4.tar.gz
TERMUX_PKG_DEPENDS="libexpat, libusb"

termux_step_post_extract_package () {
	cd $TERMUX_PKG_SRCDIR
	mv gpsbabel/* .
}
