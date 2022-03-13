TERMUX_PKG_HOMEPAGE=http://isync.sourceforge.net
TERMUX_PKG_DESCRIPTION="IMAP and MailDir mailbox synchronizer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.4
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/isync/isync/${TERMUX_PKG_VERSION}/isync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7c3273894f22e98330a330051e9d942fd9ffbc02b91952c2f1896a5c37e700ff
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl ac_cv_header_db=no ac_cv_berkdb4=no"
TERMUX_PKG_DEPENDS="openssl, zlib"
