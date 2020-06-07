TERMUX_PKG_HOMEPAGE=https://termux.com/
TERMUX_PKG_DESCRIPTION="Basic system tools for Termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.81
TERMUX_PKG_REVISION=3
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_CONFLICTS="procps (<< 3.3.15-2)"
TERMUX_PKG_SUGGESTS="termux-api"
TERMUX_PKG_CONFFILES="etc/motd"

# Some of these packages are not dependencies and used only to ensure
# that core packages are installed after upgrading (we removed busybox
# from essentials).
TERMUX_PKG_DEPENDS="bzip2, coreutils, curl, dash, diffutils, findutils, gawk, grep, gzip, less, procps, psmisc, sed, tar, termux-am, termux-exec, util-linux, xz-utils, dialog"

# Optional packages that are distributed as part of bootstrap archives.
TERMUX_PKG_RECOMMENDS="ed, dos2unix, inetutils, net-tools, patch, unzip"

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/bin/applets
	# Remove LD_LIBRARY_PATH from environment to avoid conflicting
	# with system libraries that system binaries may link against:
	for tool in df getprop logcat mount ping ping6 ip pm settings top umount; do
		WRAPPER_FILE=$TERMUX_PREFIX/bin/$tool
		echo '#!/bin/sh' > $WRAPPER_FILE
		echo 'unset LD_LIBRARY_PATH LD_PRELOAD' >> $WRAPPER_FILE
		# Some tools require having /system/bin/app_process in the PATH,
		# at least am&pm on a Nexus 6p running Android 6.0:
		echo -n 'PATH=$PATH:/system/bin ' >> $WRAPPER_FILE
		echo "exec /system/bin/$tool \"\$@\"" >> $WRAPPER_FILE
		chmod +x $WRAPPER_FILE
	done

	for script in chsh dalvikvm login pkg su termux-fix-shebang termux-info \
		termux-open termux-open-url termux-reload-settings termux-reset \
		termux-setup-storage termux-wake-lock termux-wake-unlock termux-change-repo; do
			install -Dm700 $TERMUX_PKG_BUILDER_DIR/$script $TERMUX_PREFIX/bin/$script
			sed -i -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
				-e "s|@TERMUX_HOME@|${TERMUX_ANDROID_HOME}|g" \
				-e "s|@TERMUX_CACHE_DIR@|$(realpath ${TERMUX_PREFIX}/../../cache)|g" \
				$TERMUX_PREFIX/bin/$script
	done

	install -Dm600 $TERMUX_PKG_BUILDER_DIR/motd $TERMUX_PREFIX/etc/motd
	ln -sfr $TERMUX_PREFIX/bin/termux-open $TERMUX_PREFIX/bin/xdg-open
}
