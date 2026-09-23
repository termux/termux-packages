TERMUX_PKG_HOMEPAGE=https://pagure.io/mailcap
TERMUX_PKG_DESCRIPTION="List of standard media types and their usual file extension"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="14.0.0"
TERMUX_PKG_SRCURL=https://salsa.debian.org/debian/media-types/-/archive/debian/${TERMUX_PKG_VERSION}/media-types-debian-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=55224557676d1d073b1c39ab9c26acfaab7ffe52bd1f6e013e652955da8850bb
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(
		curl -fsSL --retry 5 "https://sources.debian.org/api/src/media-types/" |
			jq -r '.versions[] | select(.suites | index("sid")) | .version'
	)"
	if [[ -z "$latest_version" ]]; then
		termux_error_exit "Unable to determine latest media-types version."
	fi
	termux_pkg_upgrade_version "$latest_version"
}
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BREAKS="mime-support"
TERMUX_PKG_REPLACES="mime-support"
TERMUX_PKG_PROVIDES="mime-support"
TERMUX_PKG_CONFFILES="etc/mime.types"
# etc/mime.types was previously in mutt:
TERMUX_PKG_CONFLICTS="mutt (<< 1.8.3-1)"

termux_step_make_install() {
	install -Dm600 "$TERMUX_PKG_SRCDIR/mime.types" "$TERMUX_PREFIX/etc/mime.types"
}
