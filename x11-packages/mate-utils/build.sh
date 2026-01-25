TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Common MATE utilities for viewing disk usage, logs and fonts, taking screenshots, managing dictionaries and searching files"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-utils/releases/download/v$TERMUX_PKG_VERSION/mate-utils-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=58449d7a0d1d900ff03b78ca9f7e98c21e97f47fc26bee7ff1c61834f22f88d3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="mate-desktop, gettext, libcanberra, libgtop, libsm, libxml2"
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
