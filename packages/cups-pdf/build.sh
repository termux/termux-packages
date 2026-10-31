TERMUX_PKG_HOMEPAGE=https://www.cups-pdf.de/
TERMUX_PKG_DESCRIPTION="CUPS PDF backend"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.3"
TERMUX_PKG_SRCURL="https://www.cups-pdf.de/src/cups-pdf_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4a66e16976b30f3c6df5ed113ed9d6e13f7f34617eab349f70b0382fce54e08b
TERMUX_PKG_DEPENDS="cups, ghostscript"
TERMUX_PKG_CONFFILES="etc/cups/cups-pdf.conf"

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS $TERMUX_PKG_SRCDIR/src/cups-pdf.c \
		-o cups-pdf $LDFLAGS -lcups
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/lib/cups/backend \
		cups-pdf
	install -Dm600 -t $TERMUX_PREFIX/etc/cups \
		$TERMUX_PKG_SRCDIR/extra/cups-pdf.conf
	install -Dm600 -t $TERMUX_PREFIX/share/cups/model \
		$TERMUX_PKG_SRCDIR/extra/CUPS-PDF_opt.ppd
}
