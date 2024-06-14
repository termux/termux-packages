#!@TERMUX_PREFIX@/bin/bash

# --- boot-set-up-pkgs.sh ---
# This script runs the packages 'postinst' function.
# They are not run during the creation of bootstrap based
# on pacman as this is not possible. They must be running
# on Termux devices for the packages to function completely properly.
#
# This script is one-time only. After launching, it will
# be automatically deleted to avoid running it again.

(
export TERMUX_PREFIX="@TERMUX_PREFIX@"
export TERMUX_PACKAGE_MANAGER="@TERMUX_PACKAGE_MANAGER@"

_boot_message() {
	echo "[*] ${1}"
}

_boot_message "Automatic one-time setup of packages has been launched, setup is in progress..."

case "${TERMUX_PACKAGE_MANAGER}" in
	"pacman")
		for i in ${TERMUX_PREFIX}/var/lib/pacman/local/*/install; do
			(
				source $i
				if type post_install &> /dev/null; then
					DIR="${i::-8}"
					_boot_message "Setting up the ${DIR##*/} package..."
					post_install &> /dev/null || true
				fi
			)
		done;;
	"apt")
		for i in ${TERMUX_PREFIX}/var/lib/dpkg/info/*.postinst; do
			DIR="${i##*/}"
			_boot_message "Setting up the ${DIR::-9} package..."
			bash $i
		done;;
	*)
		_boot_message "unknown package manager '${TERMUX_PACKAGE_MANAGER}', because of this it is not possible to configure packages"
esac

_boot_message "Setting up packages is complete, pleasant use Termux :)"

rm ${BASH_SOURCE[0]}
)
