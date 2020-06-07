TERMUX_PKG_HOMEPAGE=https://busybox.net/
TERMUX_PKG_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.31.1
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://busybox.net/downloads/busybox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d0f940a72f648943c1f2211e0e3117387c31d765137d92bd8284a3fb9752a998
TERMUX_PKG_BUILD_IN_SRC=true
# We replace env in the old coreutils package:
TERMUX_PKG_CONFLICTS="coreutils (<< 8.25-4)"
TERMUX_PKG_SERVICE_SCRIPT=(
	"telnetd" 'exec busybox telnetd -F'
	"ftpd" 'exec busybox tcpsvd -vE 0.0.0.0 8021 busybox ftpd $HOME'
	"crond" 'exec busybox crond -f -d 0 2>&1'
)

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_configure() {
	# Prevent spamming logs with useless warnings to make them more readable.
	CFLAGS+=" -Wno-ignored-optimization-argument -Wno-unused-command-line-argument"

	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_SYSROOT@|$TERMUX_STANDALONE_TOOLCHAIN/sysroot|g" \
		-e "s|@TERMUX_HOST_PLATFORM@|${TERMUX_HOST_PLATFORM}|g" \
		-e "s|@TERMUX_CFLAGS@|$CFLAGS|g" \
		-e "s|@TERMUX_LDFLAGS@|$LDFLAGS|g" \
		-e "s|@TERMUX_LDLIBS@|log|g" \
		$TERMUX_PKG_BUILDER_DIR/busybox.config > .config

	unset CFLAGS LDFLAGS
	make oldconfig
}

termux_step_post_make_install() {
	if $TERMUX_DEBUG; then
		install -Dm700 busybox_unstripped $PREFIX/bin/busybox
	fi

	# Utilities (like crond/crontab) are useful but not available
	# as standalone package in Termux.
	#
	# Few notes:
	#
	#  * runsv, runsvdir, sv - for things like in https://github.com/termux/termux-packages/pull/3460.
	#  * tcpsvd - required for ftpd applet.
	#
	rm -Rf $TERMUX_PREFIX/bin/applets
	mkdir -p $TERMUX_PREFIX/bin/applets
	cd $TERMUX_PREFIX/bin/applets
	for f in crond crontab inotifyd lsusb runsv runsvdir sendmail sv svlogd; do
		ln -s ../busybox $f
	done
	unset f

	# Install busybox man page
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/docs/busybox.1 $TERMUX_PREFIX/share/man/man1

	# Needed for 'crontab -e' to work out of the box:
	local _CRONTABS=$TERMUX_PREFIX/var/spool/cron/crontabs
	mkdir -p $_CRONTABS
	echo "Used by the busybox crontab and crond tools" > $_CRONTABS/README.termux
}
