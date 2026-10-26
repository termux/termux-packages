TERMUX_PKG_HOMEPAGE=https://www.cyrusimap.org/
TERMUX_PKG_DESCRIPTION="Cyrus IMAP Server"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Lockywolf"
TERMUX_PKG_VERSION="3.12.4"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/cyrusimap/cyrus-imapd/releases/download/cyrus-imapd-$TERMUX_PKG_VERSION/cyrus-imapd-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=87a39e27208d9019f00608483d532eb05bd0d71394a6f3f8bb05a72833ad8d91
TERMUX_PKG_DEPENDS="libsasl,bison,flex,libjansson,libical"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
"
termux_step_pre_configure() {
    CFLAGS+=" -Wno-error=implicit-function-declaration -D_GNU_SOURCE -D_BSD_SOURCE"
    sed -i 's/ulong /unsigned long /g' imap/httpd.h imap/http_client.h imap/jmap_mail_submission.c
}

