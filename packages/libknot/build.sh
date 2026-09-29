TERMUX_PKG_HOMEPAGE=https://www.knot-dns.cz/
TERMUX_PKG_DESCRIPTION="Knot DNS libraries"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.0
TERMUX_PKG_SRCURL=https://secure.nic.cz/files/knot-dns/knot-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=922894f04a2835131a24c3b3edcbf761273c1b37d3dc4e46d6923ee3856af130
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libgnutls, liblmdb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-daemon
--disable-modules
--enable-utilities
"

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(
		curl -fsSL --retry 5 "https://gitlab.nic.cz/api/v4/projects/knot%2Fknot-dns/repository/tags?per_page=50" |
			jq -r '.[].name | select(test("^v[0-9]+\\.[0-9]+\\.[0-9]+$")) | ltrimstr("v")' |
			sort -V | tail -n1
	)"
	if [[ -z "$latest_version" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi
	termux_pkg_upgrade_version "$latest_version"
}

termux_step_pre_configure() {
	CPPFLAGS+=" -DMDB_USE_ROBUST=0"
}
