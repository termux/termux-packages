TERMUX_PKG_HOMEPAGE=http://isync.sourceforge.net
TERMUX_PKG_DESCRIPTION="IMAP and MailDir mailbox synchronizer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/isync/isync/${TERMUX_PKG_VERSION}/isync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=28cc90288036aa5b6f5307bfc7178a397799003b96f7fd6e4bd2478265bb22fa
TERMUX_PKG_DEPENDS="openssl, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-sasl
ac_cv_header_db=no
ac_cv_berkdb4=no
"
