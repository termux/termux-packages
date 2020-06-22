TERMUX_PKG_HOMEPAGE=https://gnunet.org/en/gnurl.html
TERMUX_PKG_DESCRIPTION="Fork of libcurl, which is mostly for GNUnet"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=7.70.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/gnunet/gnurl-$TERMUX_PKG_VERSION.tar.Z
TERMUX_PKG_SHA256=1df60fe2b464270bf37683ea21813520dce3fdcfbf7c554e2a52d65c155df014
TERMUX_PKG_DEPENDS="libgnutls, libnghttp2"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-dict \
--disable-file \
--disable-ftp \
--disable-gopher \
--disable-imap \
--disable-ldap \
--disable-ldaps \
--disable-ntlm-wb \
--disable-pop3 \
--disable-rtsp \
--disable-smb \
--disable-smtp \
--disable-telnet \
--disable-tftp \
--enable-ipv6 \
--enable-manual \
--enable-versioned-symbols \
--enable-threaded-resolver \
--without-gssapi \
--with-gnutls \
--without-libidn \
--without-libpsl \
--without-librtmp \
--without-ssl \
--disable-ftp \
--disable-file \
--with-random=/dev/urandom \
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-ca-path=$TERMUX_PREFIX/etc/tls/certs
"
