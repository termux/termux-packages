TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/nmh/
TERMUX_PKG_DESCRIPTION="Powerful electronic mail handling system"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.1
TERMUX_PKG_REVISION=9
TERMUX_PKG_SRCURL=http://download.savannah.nongnu.org/releases/nmh/nmh-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f1fb94bbf7d95fcd43277c7cfda55633a047187f57afc6c1bb9321852bd07c11
TERMUX_PKG_DEPENDS="gdbm, libdb, libiconv, libsasl, openssl"
TERMUX_PKG_BUILD_DEPENDS="ncurses"

# We don't have complete sendmail utility.
# Using here a one from busybox, even if it may not work.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_sendmailpath=$TERMUX_PREFIX/bin/applets/sendmail
--with-cyrus-sasl
--with-tls"

TERMUX_PKG_CONFFILES="
etc/nmh/MailAliases
etc/nmh/components
etc/nmh/digestcomps
etc/nmh/distcomps
etc/nmh/forwcomps
etc/nmh/mhl.body
etc/nmh/mhl.digest
etc/nmh/mhl.format
etc/nmh/mhl.forward
etc/nmh/mhl.headers
etc/nmh/mhl.reply
etc/nmh/mhn.defaults
etc/nmh/mts.conf
etc/nmh/rcvdistcomps
etc/nmh/rcvdistcomps.outbox
etc/nmh/replcomps
etc/nmh/replgroupcomps
etc/nmh/scan.MMDDYY
etc/nmh/scan.YYYYMMDD
etc/nmh/scan.default
etc/nmh/scan.mailx
etc/nmh/scan.nomime
etc/nmh/scan.size
etc/nmh/scan.time
etc/nmh/scan.timely
etc/nmh/scan.unseen"

termux_step_pre_configure() {
	TERMUX_MAKE_PROCESSES=1
	autoreconf -fi
}

termux_step_post_make_install() {
	# We disabled hardlinks with a patch. Replace them with
	# symlinks here.
	ln -sfr "$TERMUX_PREFIX"/bin/flist "$TERMUX_PREFIX"/bin/flists
	ln -sfr "$TERMUX_PREFIX"/bin/folder "$TERMUX_PREFIX"/bin/folders
	ln -sfr "$TERMUX_PREFIX"/bin/new "$TERMUX_PREFIX"/bin/fnext
	ln -sfr "$TERMUX_PREFIX"/bin/new "$TERMUX_PREFIX"/bin/fprev
	ln -sfr "$TERMUX_PREFIX"/bin/new "$TERMUX_PREFIX"/bin/unseen
	ln -sfr "$TERMUX_PREFIX"/bin/show "$TERMUX_PREFIX"/bin/prev
	ln -sfr "$TERMUX_PREFIX"/bin/show "$TERMUX_PREFIX"/bin/next
}
