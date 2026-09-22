TERMUX_PKG_HOMEPAGE=https://dev.lovelyhq.com/libburnia
TERMUX_PKG_DESCRIPTION="Frontend for libraries libburn and libisofs"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.8.pl02"
TERMUX_PKG_SRCURL=https://files.libburnia-project.org/releases/libisoburn-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a977b03dc3686d9fdca600458b1578f9cac2b875609bd5ec21f5ada55f20ec50
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libburn, libisofs, readline"
TERMUX_PKG_CONFLICTS="xorriso"
TERMUX_PKG_BREAKS="libisoburn-dev"
TERMUX_PKG_REPLACES="libisoburn-dev"

termux_pkg_auto_update() {
	local url="https://files.libburnia-project.org/releases/" latest_version
	latest_version="$(curl --fail --silent --show-error --location --retry 5 "$url" | sed -rn 's|.*libisoburn-([0-9]+(\.[0-9]+)+(\.pl[0-9]+)?)\.tar\.gz.*|\1|p' | sort -Vr | head -n1)"
	if [[ -z "$latest_version" ]]; then
		termux_error_exit "Unable to get the latest libisoburn version."
	fi
	termux_pkg_upgrade_version "$latest_version"
}

# We don't have tk.
TERMUX_PKG_RM_AFTER_INSTALL="bin/xorriso-tcltk"
