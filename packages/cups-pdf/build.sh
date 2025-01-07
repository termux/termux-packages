TERMUX_PKG_HOMEPAGE=https://www.cups-pdf.de/
TERMUX_PKG_DESCRIPTION="CUPS PDF backend"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=https://www.cups-pdf.de/src/cups-pdf_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=738669edff7f1469fe5e411202d87f93ba25b45f332a623fb607d49c59aa9531
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
