TERMUX_PKG_HOMEPAGE=http://www.busybox.net/
TERMUX_PKG_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_VERSION=1.24.2
TERMUX_PKG_BUILD_REVISION=7
TERMUX_PKG_SRCURL=http://www.busybox.net/downloads/busybox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_BUILD_IN_SRC=yes
# We replace env in the old coreutils package:
TERMUX_PKG_CONFLICTS="coreutils (<< 8.25-4)"

# NOTE: sed on mac does not work for building busybox, install gnu-sed with
#       homebrew using the --with-default-names option.

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
	echo "CONFIG_SV_DEFAULT_SERVICE_DIR=\"$TERMUX_PREFIX/var/service\"" >> .config
	make oldconfig
}

termux_step_post_make_install () {
	# Create symlinks in $PREFIX/bin/applets to $PREFIX/bin/busybox
	rm -Rf $TERMUX_PREFIX/bin/applets
	mkdir -p $TERMUX_PREFIX/bin/applets
	cd $TERMUX_PREFIX/bin/applets
	for f in `cat $TERMUX_PKG_SRCDIR/busybox.links`; do ln -s ../busybox `basename $f`; done

        # The 'ash' and 'env' applets are special in that they go into $PREFIX/bin:
	cd $TERMUX_PREFIX/bin
	ln -f -s busybox ash
	ln -f -s busybox env

	# Install busybox man page
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/docs/busybox.1 $TERMUX_PREFIX/share/man/man1

	# Needed for 'crontab -e' to work out of the box:
	local _CRONTABS=$TERMUX_PREFIX/var/spool/cron/crontabs
	mkdir -p $_CRONTABS
	echo "Used by the busybox crontab and crond tools" > $_CRONTABS/README.termux

	# Setup some services
	mkdir -p $TERMUX_PREFIX/var/service
	cd $TERMUX_PREFIX/var/service
	mkdir -p ftpd telnetd
	echo '#!/bin/sh' > ftpd/run
	echo 'exec tcpsvd -vE 0.0.0.0 8021 ftpd /data/data/com.termux/files/home' >> ftpd/run
	echo '#!/bin/sh' > telnetd/run
	echo 'exec telnetd -F' >> telnetd/run
	chmod +x */run
}

