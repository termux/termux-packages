TERMUX_PKG_HOMEPAGE=https://invisible-island.net/dialog/
TERMUX_PKG_DESCRIPTION="Application used in shell scripts which displays text user interface widgets"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_VERSION="1.3-20260107"
TERMUX_PKG_SRCURL="https://invisible-island.net/archives/dialog/dialog-${TERMUX_PKG_VERSION}.tgz"
TERMUX_PKG_SHA256=78b3dd18d95e50f0be8f9b9c1e7cffe28c9bf1cdf20d5b3ef17279c4da35c5b5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ncursesw
--enable-widec
--with-pkg-config
"

termux_pkg_auto_update() {
	local latest_version version_part date_part
	latest_version="$(termux_repology_api_get_latest_version "${TERMUX_PKG_NAME}")"
	# dialog is commonly packaged with a '-', '.', '_' or '+' delimiter
	# between the version and date parts. We want to normalize that to a '-'.
	version_part="${latest_version%[^0-9]*}"
	date_part="${latest_version##*[^0-9]}"

	if [[ -z "$version_part" || -z "$date_part" ]]; then
		termux_error_exit <<-EOF
			Couldn't parse latest_version for '$TERMUX_PKG_NAME'
			Current version: $TERMUX_PKG_VERSION
			Fetched version: $latest_version
			Version part   : $version_part
			Date part      : $date_part
		EOF
	# Sanity check that the new version is newer than the current one.
	elif (( date_part < ${TERMUX_PKG_VERSION##*[^0-9]} )); then
		termux_error_exit <<-EOF
			Reported latest_version appears to be older than what we package?
			Current version: $TERMUX_PKG_VERSION
			Reported latest: $latest_version
		EOF
	fi

	termux_pkg_upgrade_version "${version_part}-${date_part}"
}

termux_step_pre_configure() {
	# Put a temporary link for libtinfo.so
	ln -sf "$TERMUX_PREFIX/lib/libncursesw.so" "$TERMUX_PREFIX/lib/libtinfo.so"
}

termux_step_post_make_install() {
	rm "$TERMUX_PREFIX/lib/libtinfo.so"
}
