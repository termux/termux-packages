TERMUX_PKG_HOMEPAGE=https://busybox.net/
TERMUX_PKG_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.32.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://busybox.net/downloads/busybox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c35d87f1d04b2b153d33c275c2632e40d388a88f19a9e71727e0bbbff51fe689
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_SERVICE_SCRIPT=(
	"telnetd" 'exec busybox telnetd -F'
	"ftpd" 'exec busybox tcpsvd -vE 0.0.0.0 8021 busybox ftpd -w $HOME'
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

	# Install busybox man page.
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 $TERMUX_PKG_SRCDIR/docs/busybox.1
}
