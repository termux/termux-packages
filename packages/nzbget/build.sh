TERMUX_PKG_HOMEPAGE=https://nzbget.com/
TERMUX_PKG_DESCRIPTION="The most efficient usenet downloader"
# License: GPL-2.0-with-OpenSSL-exception
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.0"
TERMUX_PKG_SRCURL="https://github.com/nzbgetcom/nzbget/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=9b683ce96d7a2e5e702a169e3fbfd16824cfe0ce8ed887c76cc25a574f69c9cd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, libxml2, ncurses, openssl, 7zip, zlib"
TERMUX_PKG_RECOMMENDS="unrar"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=("nzbget" 'exec nzbget -s 2>&1')

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "if [ -z \"\$2\" ]; then" >> postinst # Run only on fresh install, not on upgrade
	echo "sed -e 's|^\(CertStore=\).*|\1$TERMUX_PREFIX/etc/tls/cert.pem|g" >> postinst
	echo "s|^\(ControlPassword=\).*|\1|g' $TERMUX_PREFIX/share/nzbget/nzbget.conf > $TERMUX_PREFIX/etc/nzbget.conf" >> postinst
	echo "fi" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
