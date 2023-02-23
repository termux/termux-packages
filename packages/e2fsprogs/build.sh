TERMUX_PKG_HOMEPAGE=http://e2fsprogs.sourceforge.net
TERMUX_PKG_DESCRIPTION="EXT 2/3/4 filesystem utilities"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="NOTICE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.47.0
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v$TERMUX_PKG_VERSION/e2fsprogs-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=144af53f2bbd921cef6f8bea88bb9faddca865da3fbc657cc9b4d2001097d5db
TERMUX_PKG_CONFFILES="etc/mke2fs.conf"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_DEPENDS="libblkid, libuuid"
TERMUX_PKG_BREAKS="e2fsprogs-dev"
TERMUX_PKG_REPLACES="e2fsprogs-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sbindir=${TERMUX_PREFIX}/bin
--enable-symlink-install
--enable-relative-symlinks
--disable-defrag
--disable-e2initrd-helper
--disable-libuuid
--disable-libblkid
--disable-uuidd
--with-crond_dir=${TERMUX_PREFIX}/etc/cron.d"

# Remove com_err.h to avoid conflicting with krb5-dev:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/compile_et
bin/e2scrub
bin/e2scrub_all
bin/mk_cmds
etc/cron.d
etc/e2scrub.conf
include/com_err.h
lib/e2fsprogs
share/et
share/ss
share/man/man1/compile_et.1
share/man/man1/mk_cmds.1
share/man/man8/e2scrub.8.gz
share/man/man8/e2scrub_all.8.gz"

termux_step_make_install() {
	make install install-libs
	install -Dm600 \
		"$TERMUX_PKG_SRCDIR"/misc/mke2fs.conf.in \
		"$TERMUX_PREFIX"/etc/mke2fs.conf
}
