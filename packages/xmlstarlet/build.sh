TERMUX_PKG_HOMEPAGE=https://xmlstar.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command line XML toolkit"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/${TERMUX_PKG_VERSION}/xmlstarlet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=15d838c4f3375332fd95554619179b69e4ec91418a3a5296e7c631b7ed19e7ca
TERMUX_PKG_DEPENDS="libxslt, libxml2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libxml-include-prefix=${TERMUX_PREFIX}/include/libxml2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(curl --silent https://sourceforge.net/projects/xmlstar/files/xmlstarlet/ | grep -oP '/files/xmlstarlet/\K[0-9]+(\.[0-9]+)+(?=/)' | sort -V | tail -n1)"

	if [[ -z "${latest_version}" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_make_install() {
	ln -sfr $TERMUX_PREFIX/bin/xml $TERMUX_PREFIX/bin/xmlstarlet
}
