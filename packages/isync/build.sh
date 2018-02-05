TERMUX_PKG_HOMEPAGE=http://isync.sourceforge.net
TERMUX_PKG_DESCRIPTION="IMAP and MailDir mailbox synchronizer"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/isync/isync/${TERMUX_PKG_VERSION}/isync-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8d5f583976e3119705bdba27fa4fc962e807ff5996f24f354957178ffa697c9c
TERMUX_PKG_DEPENDS="readline-dev"
TERMUX_PKG_RECOMMENDS="openssl-dev, libsasl-dev, libdb-dev, libzopfli"
termux_step_pre_configure() {
	LDFLAGS+=" -lreadline"
}
