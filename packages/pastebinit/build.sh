TERMUX_PKG_HOMEPAGE=https://launchpad.net/pastebinit
TERMUX_PKG_DESCRIPTION="Command-line pastebin client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.5
TERMUX_PKG_SRCURL=https://launchpad.net/pastebinit/trunk/${TERMUX_PKG_VERSION}/+download/pastebinit-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=42e5a84ce7e46825fb3b6478e11893fad357197327257e474bd0d3549f438457
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	cp pastebinit $TERMUX_PREFIX/bin/
	xsltproc -''-nonet /usr/share/sgml/docbook/stylesheet/xsl/nwalsh/manpages/docbook.xsl pastebinit.xml
	cp pastebinit.1 $TERMUX_PREFIX/share/man/man1/

	rm -Rf $TERMUX_PREFIX/etc/pastebin.d
	mv pastebin.d $TERMUX_PREFIX/etc
}
