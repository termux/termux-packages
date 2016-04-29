TERMUX_PKG_HOMEPAGE=http://www.busybox.net/
TERMUX_PKG_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_VERSION=1.24.2
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://www.busybox.net/downloads/busybox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_BUILD_IN_SRC=yes

# NOTE: sed on mac does not work for building busybox, install gsed and symlink sed => gsed

CFLAGS+=" -llog -DTERMUX_EXPOSE_MEMPCPY=1" # Android system liblog.so for syslog

termux_step_configure () {
	# Bug in gold linker with busybox in android r10e:
	# https://sourceware.org/ml/binutils/2015-02/msg00386.html
	CFLAGS+=" -fuse-ld=bfd"
	LD+=.bfd

	cp $TERMUX_PKG_BUILDER_DIR/busybox.config .config
	echo "CONFIG_SYSROOT=\"$TERMUX_STANDALONE_TOOLCHAIN/sysroot\"" >> .config
	echo "CONFIG_PREFIX=\"$TERMUX_PREFIX\"" >> .config
	echo "CONFIG_CROSS_COMPILER_PREFIX=\"${TERMUX_HOST_PLATFORM}-\"" >> .config
	echo "CONFIG_FEATURE_CROND_DIR=\"$TERMUX_PREFIX/var/spool/cron\"" >> .config
	make oldconfig
}

termux_step_post_make_install () {
	# Create symlinks in $PREFIX/bin/applets to $PREFIX/bin/busybox
	rm -Rf $TERMUX_PREFIX/bin/applets
	mkdir -p $TERMUX_PREFIX/bin/applets
	cd $TERMUX_PREFIX/bin/applets
	for f in `cat $TERMUX_PKG_SRCDIR/busybox.links`; do ln -s ../busybox `basename $f`; done

	cd $TERMUX_PREFIX/bin
	rm -f ash
	ln -s busybox ash

	# Install busybox man page
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/docs/busybox.1 $TERMUX_PREFIX/share/man/man1

	# Needed for 'crontab -e' to work out of the box:
	local _CRONTABS=$TERMUX_PREFIX/var/spool/cron/crontabs
	mkdir -p $_CRONTABS
	echo "Used by the busybox crontab and crond tools" > $_CRONTABS/README.termux
}

