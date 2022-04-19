TERMUX_PKG_HOMEPAGE=https://www.xpdfreader.com/
TERMUX_PKG_DESCRIPTION="Xpdf is an open source viewer for Portable Document Format (PDF) files."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.03
TERMUX_PKG_REVISION=4
#TERMUX_PKG_SRCURL=https://dl.xpdfreader.com/xpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SRCURL=https://ftp-osl.osuosl.org/pub/gentoo/distfiles/xpdf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0fe4274374c330feaadcebb7bd7700cb91203e153b26aa95952f02bf130be846
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtsvg"

# Remove files conflicting with poppler:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/pdfdetach
bin/pdffonts
bin/pdfimages
bin/pdfinfo
bin/pdftohtml
bin/pdftoppm
bin/pdftops
bin/pdftotext
share/man/man1/pdfdetach.1
share/man/man1/pdffonts.1
share/man/man1/pdfimages.1
share/man/man1/pdfinfo.1
share/man/man1/pdftohtml.1
share/man/man1/pdftoppm.1
share/man/man1/pdftops.1
share/man/man1/pdftotext.1
"
