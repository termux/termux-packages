TERMUX_PKG_HOMEPAGE=https://busybox.net/
TERMUX_PKG_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_VERSION=1.28.3
TERMUX_PKG_SHA256=ad0d22033f23e696f9a71a4c2f9210194dda39b024a79151f4ac278995332a6e
TERMUX_PKG_SRCURL=https://busybox.net/downloads/busybox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CLANG=no
# We replace env in the old coreutils package:
TERMUX_PKG_CONFLICTS="coreutils (<< 8.25-4)"

termux_step_pre_configure () {
	CFLAGS+=" -llog" # Android system liblog.so for syslog
}

termux_step_configure () {
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

	# The 'env' applet is special in that it go into $PREFIX/bin:
	cd $TERMUX_PREFIX/bin
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

