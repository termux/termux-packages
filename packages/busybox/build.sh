TERMUX_PKG_HOMEPAGE=https://busybox.net/
TERMUX_PKG_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.37.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://busybox.net/downloads/busybox-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3311dff32e746499f4df0d5df04d7eb396382d7e108bb9250e7b519b837043a4
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_SERVICE_SCRIPT=(
	"telnetd" 'exec busybox telnetd -F'
	"ftpd" "exec busybox tcpsvd -vE 0.0.0.0 8021 busybox ftpd -w $TERMUX_ANDROID_HOME"
	"busybox-httpd" "exec busybox httpd -f -p 0.0.0.0:8080 -h $TERMUX_PREFIX/srv/www/ 2>&1"
)

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
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
		"$TERMUX_PKG_BUILDER_DIR/busybox.config" > .config
	unset CFLAGS LDFLAGS
	make oldconfig
}

termux_step_make_install() {
	# Using unstripped variant. The post-massage step will strip binaries anyway.
	install -Dm700 "./0_lib/busybox_unstripped" "$TERMUX_PREFIX/bin/busybox"
	install -Dm700 "./0_lib/libbusybox.so.${TERMUX_PKG_VERSION}_unstripped" "$TERMUX_PREFIX/lib/libbusybox.so.${TERMUX_PKG_VERSION}"
	ln -sfr "$TERMUX_PREFIX/lib/libbusybox.so.${TERMUX_PKG_VERSION}" "$TERMUX_PREFIX/lib/libbusybox.so"

	# Install busybox man page.
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1" "$TERMUX_PKG_SRCDIR/docs/busybox.1"

	# Symlink ash -> busybox
	ln -sfr "$TERMUX_PREFIX"/bin/{busybox,ash}
	ln -sfr "$TERMUX_PREFIX"/share/man/man1/{busybox,ash}.1

	mkdir -p "$TERMUX_PREFIX/libexec/busybox"

	local applet
	for applet in 'less' 'nc' 'vi'; do
		{ # Set up a wrapper script to be called by `update-alternatives`
			echo "#!$TERMUX_PREFIX/bin/sh"
			echo "exec busybox $applet \"\$@\""
		} > "$TERMUX_PREFIX/libexec/busybox/$applet"
		chmod 700 "$TERMUX_PREFIX/libexec/busybox/$applet"
	done
}
