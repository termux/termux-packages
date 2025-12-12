TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/python3-xapp
TERMUX_PKG_DESCRIPTION="XApp library Python bindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.1"
TERMUX_PKG_SRCURL=https://github.com/linuxmint/python3-xapp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9083f64b80040aca6c20ede688f5f1e86ce90dbd808846400c5612fffde8a6ce
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="python, xapp"
TERMUX_PKG_BREAKS="python3-xapp"
TERMUX_PKG_REPLACES="python3-xapp"
TERMUX_PKG_CONFLICTS="python3-xapp"

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags "$TERMUX_PKG_HOMEPAGE.git" \
		| grep -oP "refs/tags/\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
		| sort -V \
		| tail -n1)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

termux_step_configure() {
	termux_setup_meson
	export PYTHON_SITELIB="$TERMUX_PYTHON_HOME/site-packages"
	$TERMUX_MESON setup "$TERMUX_PKG_BUILDDIR" "$TERMUX_PKG_SRCDIR" \
		-Dlocaledir="$TERMUX_PREFIX"/share/locale \
		-Dpython.purelibdir="$PYTHON_SITELIB"
}
