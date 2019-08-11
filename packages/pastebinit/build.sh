TERMUX_PKG_HOMEPAGE=https://launchpad.net/pastebinit
TERMUX_PKG_DESCRIPTION="Command-line pastebin client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_SRCURL=https://launchpad.net/pastebinit/trunk/${TERMUX_PKG_VERSION}/+download/pastebinit-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5f789eedbfef7c9cc54d3ea3fa9807637cdb558e51e0b59150ff9354f88632b1
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if [ -n "$TERMUX_ON_DEVICE_BUILD" ]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_make_install() {
	cp pastebinit $TERMUX_PREFIX/bin/
	xsltproc -''-nonet /usr/share/sgml/docbook/stylesheet/xsl/nwalsh/manpages/docbook.xsl pastebinit.xml
	cp pastebinit.1 $TERMUX_PREFIX/share/man/man1/

	rm -Rf $TERMUX_PREFIX/etc/pastebin.d
	mv pastebin.d $TERMUX_PREFIX/etc
}
