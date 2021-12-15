TERMUX_PKG_HOMEPAGE=http://mailsync.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A way of synchronizing a collection of mailboxes"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.7
TERMUX_PKG_SRCURL=https://master.dl.sourceforge.net/project/mailsync/mailsync/${TERMUX_PKG_VERSION}/mailsync_${TERMUX_PKG_VERSION}-1.tar.gz
TERMUX_PKG_SHA256=041bff09050d7c57134b53455e9dc7f858c1f8ba968e0cee6c73a226793aa833
TERMUX_PKG_DEPENDS="libc++, libc-client"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-c-client=$TERMUX_PREFIX"

termux_step_pre_configure() {
	autoreconf -fi
}
