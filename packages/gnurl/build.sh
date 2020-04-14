TERMUX_PKG_HOMEPAGE=https://gnunet.org/gnurl
TERMUX_PKG_DESCRIPTION="Fork of libcurl, which is mostly for GNUnet"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=7.69.1
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/gnunet/gnurl-$TERMUX_PKG_VERSION.tar.Z
TERMUX_PKG_SHA256=06e0b29b52d85f73a35cb7b1661ed7965e05ea84c3b54aef24b862a51a20f262
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
