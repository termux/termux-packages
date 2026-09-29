TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Common MATE utilities for viewing disk usage, logs and fonts, taking screenshots, managing dictionaries and searching files"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.1"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-utils/releases/download/v$TERMUX_PKG_VERSION/mate-utils-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=8b9e882daab76314f8e6518ff8cd6ddd19f727eb1f2e9a985f7fc68bd025bf07
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-regex
TERMUX_PKG_DEPENDS="mate-desktop, gettext, gtk-layer-shell, libcanberra, libgtop, libsm, libxml2"
TERMUX_PKG_SUGGESTS="mate-panel"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, glib, inkscape, mate-common, mate-panel, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--disable-maintainer-flags
--disable-disk-image-mounter
"
TERMUX_PKG_CONFFILES="
etc/mate-system-log.conf
"

_mate_utils_is_supported_version() {
	local minor="${1#*.}"
	minor="${minor%%.*}"
	[[ "$minor" =~ ^[0-9]+$ ]] && (( 10#$minor % 2 == 0 ))
}

termux_pkg_auto_update() {
	local tags supported_tag
	tags="$(termux_github_api_get_tag)"
	supported_tag="$(grep -E '^v?[0-9]+\.[0-9]*[02468]\.[0-9]+$' <<< "$tags" | sort -Vr | head -n1)"
	if [[ -z "$supported_tag" ]]; then
		echo "INFO: No supported MATE release tag found."
		return
	fi
	if ! termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${supported_tag#v}"; then
		echo "INFO: No supported update needed."
		return
	fi
	termux_pkg_upgrade_version "$supported_tag"
}

termux_step_post_get_source() {
	_mate_utils_is_supported_version "$TERMUX_PKG_VERSION" || \
		termux_error_exit "MATE odd-minor releases are unsupported."
}

termux_step_post_make_install() {
	# populate a custom configuration file in syslog.conf-like format
	# with log file locations that are likely to exist in Termux
	mkdir -p "$TERMUX_PREFIX/etc"
	if [[ "$TERMUX_PACKAGE_FORMAT" == "debian" ]]; then
		cat <<- EOF > "$TERMUX_PREFIX/etc/mate-system-log.conf"
			$TERMUX_PREFIX/var/log/apt/history.log
			$TERMUX_PREFIX/var/log/apt/term.log
			$TERMUX_PREFIX/var/log/aptitude
			$TERMUX_PREFIX/var/log/alternatives.log
			$TERMUX_PREFIX/var/log/oma/history
			$TERMUX_PREFIX/var/log/dpkg.log
		EOF
	fi

	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		cat <<- EOF > "$TERMUX_PREFIX/etc/mate-system-log.conf"
			$TERMUX_PREFIX/var/log/pacman.log
		EOF
	fi
}
