TERMUX_PKG_HOMEPAGE=https://nzbget.net/
TERMUX_PKG_DESCRIPTION="The most efficient usenet downloader"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=20.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/nzbget/nzbget/releases/download/v${TERMUX_PKG_VERSION}/nzbget-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=04dc36d432549c33d55145ecd95cc4309b3ab4a7731a1a03d954de389eacd06f
TERMUX_PKG_DEPENDS="libxml2, ncurses, openssl, p7zip"
TERMUX_PKG_RECOMMENDS="unrar"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "if [ -z \"\$2\" ]; then" >> postinst # Run only on fresh install, not on upgrade
	echo "sed -e 's|^\(CertStore=\).*|\1$TERMUX_PREFIX/etc/tls/cert.pem|g" >> postinst
	echo "s|^\(ControlPassword=\).*|\1|g' $TERMUX_PREFIX/share/nzbget/nzbget.conf > $TERMUX_PREFIX/etc/nzbget.conf" >> postinst
	echo "fi" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
