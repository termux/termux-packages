TERMUX_PKG_HOMEPAGE=https://www.pureftpd.org/project/pure-ftpd
TERMUX_PKG_DESCRIPTION="Pure-FTPd is a free (BSD), secure, production-quality and standard-conformant FTP server"
TERMUX_PKG_VERSION=1.0.45
TERMUX_PKG_SRCURL=https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f6f26ab932e7fd2557435ee48f4fe089b2360a352b8ac7b2360cc9aaad63e92a
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-nonroot --with-minimal --with-ftpwho"
