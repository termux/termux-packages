TERMUX_PKG_HOMEPAGE=http://isync.sourceforge.net
TERMUX_PKG_DESCRIPTION="IMAP and MailDir mailbox synchronizer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/isync/isync/${TERMUX_PKG_VERSION}/isync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=68cb4643d58152097f01c9b3abead7d7d4c9563183d72f3c2a31d22bc168f0ea
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl ac_cv_header_db=no ac_cv_berkdb4=no"
TERMUX_PKG_DEPENDS="openssl, zlib"
