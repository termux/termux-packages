TERMUX_PKG_HOMEPAGE=https://termux.dev/
TERMUX_PKG_DESCRIPTION="Basic system tools for Termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24
TERMUX_PKG_REVISION=0
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BREAKS="termux-keyring (<< 1.9)"
TERMUX_PKG_CONFLICTS="procps (<< 3.3.15-2)"
TERMUX_PKG_SUGGESTS="termux-api"
TERMUX_PKG_CONFFILES="
etc/motd.sh
etc/motd-playstore
etc/profile.d/init-termux-properties.sh
etc/termux-login.sh
"

# Some of these packages are not dependencies and used only to ensure
# that core packages are installed after upgrading (we removed busybox
# from essentials).
TERMUX_PKG_DEPENDS="bzip2, coreutils, curl, dash, diffutils, findutils, gawk, grep, gzip, less, procps, psmisc, sed, tar, termux-am, termux-am-socket (>= 1.5.0), termux-exec, util-linux, xz-utils, dialog"

# Optional packages that are distributed as part of bootstrap archives.
TERMUX_PKG_RECOMMENDS="ed, dos2unix, inetutils, net-tools, patch, unzip"

termux_step_make_install() {
	# Remove LD_LIBRARY_PATH from environment to avoid conflicting
	# with system libraries that system binaries may link against:
	for tool in df getprop logcat mount ping ping6 pm settings top umount cmd; do
		WRAPPER_FILE=$TERMUX_PREFIX/bin/$tool
		echo '#!/bin/sh' > $WRAPPER_FILE
		echo 'unset LD_LIBRARY_PATH LD_PRELOAD' >> $WRAPPER_FILE
		# Some tools require having /system/bin/app_process in the PATH,
		# at least am&pm on a Nexus 6p running Android 6.0:
		echo -n 'PATH=$PATH:/system/bin ' >> $WRAPPER_FILE
		echo "exec /system/bin/$tool \"\$@\"" >> $WRAPPER_FILE
		chmod +x $WRAPPER_FILE
	done

	for script in chsh dalvikvm login pkg su termux-fix-shebang termux-backup \
		termux-info termux-open termux-open-url termux-reload-settings \
		termux-reset termux-restore termux-setup-storage termux-wake-lock \
		termux-wake-unlock termux-change-repo termux-setup-package-manager; do
			install -Dm700 $TERMUX_PKG_BUILDER_DIR/$script $TERMUX_PREFIX/bin/$script
			sed -i -e "s%\@TERMUX_APP_PACKAGE\@%${TERMUX_APP_PACKAGE}%g" \
				-e "s%\@TERMUX_BASE_DIR\@%${TERMUX_BASE_DIR}%g" \
				-e "s%\@TERMUX_CACHE_DIR\@%${TERMUX_CACHE_DIR}%g" \
				-e "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" \
				-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
				-e "s%\@PACKAGE_VERSION\@%${TERMUX_PKG_VERSION}%g" \
				-e "s%\@TERMUX_PACKAGE_FORMAT\@%${TERMUX_PACKAGE_FORMAT}%g" \
				-e "s%\@TERMUX_PACKAGE_MANAGER\@%${TERMUX_PACKAGE_MANAGER}%g" \
				$TERMUX_PREFIX/bin/$script
	done

	{
		echo 'echo ""'
		echo 'echo -e " \e[47m                \e[0m  \e[1mWelcome to Termux!\e[0m"'
		echo 'echo -e " \e[47m  \e[0m            \e[0;37m\e[47m .\e[0m"'
		echo 'echo -e " \e[47m  \e[0m  \e[47m  \e[0m        \e[47m  \e[0m  \e[1mDocs:\e[0m   \e[4mtermux.dev/docs\e[0m"'
		echo 'echo -e " \e[47m  \e[0m  \e[47m  \e[0m        \e[47m  \e[0m  \e[1mGitter:\e[0m \e[4mgitter.im/termux/termux\e[0m"'
		echo 'echo -e " \e[47m  \e[0m            \e[47m  \e[0m  \e[1mCommunity:\e[0m \e[4mtermux.dev/community\e[0m"'
		echo 'echo -e " \e[47m  \e[0m            \e[0;37m\e[47m .\e[0m"'
		echo 'echo -e " \e[47m                \e[0m  \e[1mTermux version:\e[0m ${TERMUX_VERSION-Unknown}"'
		echo 'echo ""'
		echo 'echo -e "                   \e[1mWorking with packages:\e[0m"'
		echo 'echo -e "                       \e[1mSearch:\e[0m  pkg search <query>"'
		echo 'echo -e "                       \e[1mInstall:\e[0m pkg install <package>"'
		echo 'echo -e "                       \e[1mUpdate:\e[0m  pkg update"'
		echo 'echo ""'
		if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ]; then
			echo 'echo -e "                   \e[1mSubscribing to additional repos:\e[0m"'
			echo 'echo -e "                       \e[1mRoot:\e[0m pkg install root-repo"'
			echo 'echo -e "                       \e[1mX11: \e[0m pkg install x11-repo"'
			echo 'echo ""'
			echo 'echo "                   For fixing any repository issues,"'
			echo "echo \"                   try 'termux-change-repo' command.\""
			echo 'echo ""'
		fi
		echo 'echo -e "                   Report issues at \e[4mtermux.dev/issues\e[0m"'
		echo 'echo ""'
	} > $TERMUX_PKG_BUILDER_DIR/motd.sh
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/motd.sh $TERMUX_PREFIX/etc/motd.sh
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/motd-playstore $TERMUX_PREFIX/etc/motd-playstore
	ln -sfr $TERMUX_PREFIX/bin/termux-open $TERMUX_PREFIX/bin/xdg-open

	mkdir -p $TERMUX_PREFIX/share/man/man1
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" -e "s|@TERMUX_HOME@|${TERMUX_ANDROID_HOME}|g" \
		$TERMUX_PKG_BUILDER_DIR/termux.1.md.in > $TERMUX_PKG_TMPDIR/termux.1.md
	pandoc --standalone --to man --output $TERMUX_PREFIX/share/man/man1/termux.1 \
		$TERMUX_PKG_TMPDIR/termux.1.md

	mkdir -p $TERMUX_PREFIX/share/examples/termux
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/termux.properties $TERMUX_PREFIX/share/examples/termux/

	mkdir -p $TERMUX_PREFIX/etc/profile.d
	cat <<- EOF > $TERMUX_PREFIX/etc/profile.d/init-termux-properties.sh
	if [ ! -f $TERMUX_ANDROID_HOME/.config/termux/termux.properties ] && [ ! -e $TERMUX_ANDROID_HOME/.termux/termux.properties ]; then
		mkdir -p $TERMUX_ANDROID_HOME/.termux
		cp $TERMUX_PREFIX/share/examples/termux/termux.properties $TERMUX_ANDROID_HOME/.termux/
	fi
	EOF

	cat <<- EOF > $TERMUX_PREFIX/etc/termux-login.sh
	##
	## This script is sourced by $PREFIX/bin/login before executing shell.
	##
	EOF

	mkdir -p $TERMUX_PREFIX/etc/termux
	cp -r $TERMUX_PKG_BUILDER_DIR/mirrors $TERMUX_PREFIX/etc/termux/
	cd $TERMUX_PREFIX
	TERMUX_PKG_CONFFILES+=" $(find etc/termux/mirrors -type f)"
}
