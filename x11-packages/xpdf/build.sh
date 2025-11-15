TERMUX_PKG_HOMEPAGE=https://www.xpdfreader.com/
TERMUX_PKG_DESCRIPTION="Xpdf is an open source viewer for Portable Document Format (PDF) files."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.06"
TERMUX_PKG_SRCURL=https://dl.xpdfreader.com/xpdf-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1c38f527c46caee0f712386d42a885b96a31ed9ce11904e872559859894d137e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, libc++, libpng, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

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
