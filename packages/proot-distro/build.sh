TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.13.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d2f7e9edd99303ef7d1163c3b8d19c9355ed0af0f203f96ea30d49530f7773a9
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, findutils, gzip, ncurses-utils, proot (>= 5.1.107-32), sed, tar, termux-tools, xz-utils"
TERMUX_PKG_SUGGESTS="bash-completion, termux-api"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	env TERMUX_APP_PACKAGE="$TERMUX_APP_PACKAGE" \
		TERMUX_PREFIX="$TERMUX_PREFIX" \
		TERMUX_ANDROID_HOME="$TERMUX_ANDROID_HOME" \
		./install.sh
}

termux_step_create_debscripts() {
	# Distribution manjaro-aarch64 renamed to manjaro
	cat <<- EOF > ./preinst
	#!${TERMUX_PREFIX}/bin/bash
	set -e
	PD_PLUGINS_DIR="${TERMUX_PREFIX}/etc/proot-distro"
	PD_ROOTFS_DIR="${TERMUX_PREFIX}/var/lib/proot-distro/installed-rootfs"

	if [ -e "\${PD_PLUGINS_DIR}/manjaro-aarch64.sh" ] && ! [ -e "\${PD_PLUGINS_DIR}/manjaro.sh" ]; then
		mv "\${PD_PLUGINS_DIR}/manjaro-aarch64.sh" "\${PD_PLUGINS_DIR}/manjaro.sh"
	fi

	if [ -e "\${PD_ROOTFS_DIR}/manjaro-aarch64" ] && ! [ -e "\${PD_ROOTFS_DIR}/manjaro" ]; then
		echo "PRoot-Distro upgrade note: renaming the distribution manjaro-aarch64 to manjaro..."

		mv "\${PD_ROOTFS_DIR}/manjaro-aarch64" "\${PD_ROOTFS_DIR}/manjaro"

		echo "PRoot-Distro upgrade note: fixing link2symlink extension files for manjaro, this will take few minutes..."

		# rewrite l2s proot symlinks
		find "\${PD_ROOTFS_DIR}/manjaro" -type l | while read -r symlink_file_name; do
			symlink_current_target=\$(readlink "\${symlink_file_name}")
			if [ "\${symlink_current_target:0:\${#PD_ROOTFS_DIR}}" != "\${PD_ROOTFS_DIR}" ]; then
				continue
			fi
			symlink_new_target=\$(sed -E "s@(\${PD_ROOTFS_DIR})/([^/]+)/(.*)@\1/manjaro/\3@g" <<< "\${symlink_current_target}")
			ln -sf "\${symlink_new_target}" "\${symlink_file_name}"
		done
	fi
	EOF
}
