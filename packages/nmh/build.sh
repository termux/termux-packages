TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/nmh/
TERMUX_PKG_DESCRIPTION="Powerful electronic mail handling system"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_SRCURL=https://download-mirror.savannah.gnu.org/releases/nmh/nmh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=366ce0ce3f9447302f5567009269c8bb3882d808f33eefac85ba367e875c8615
TERMUX_PKG_DEPENDS="gdbm, libcurl, libiconv, libsasl, ncurses, openssl, readline"
TERMUX_PKG_BUILD_IN_SRC=true

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
