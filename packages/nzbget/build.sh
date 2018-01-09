TERMUX_PKG_HOMEPAGE=https://nzbget.net/
TERMUX_PKG_DESCRIPTION="The most efficient usenet downloader"
TERMUX_PKG_VERSION=19.1
TERMUX_PKG_SRCURL=https://github.com/nzbget/nzbget/releases/download/v${TERMUX_PKG_VERSION}/nzbget-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=06df42356ac2d63bbc9f7861abe9c3216df56fa06802e09e8a50b05f4ad95ce6
TERMUX_PKG_DEPENDS="libxml2, ncurses, openssl, unrar, p7zip"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_c_bigendian=no"

termux_step_create_debscripts () {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "sed -e 's|^\(CertStore=\).*|\1$TERMUX_PREFIX/etc/tls/cert.pem|g" >> postinst
	echo "s|^\(ControlPassword=\).*|\1|g' $TERMUX_PREFIX/share/nzbget/nzbget.conf > ~/.nzbget" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
