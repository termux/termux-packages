TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/pcmanfm/
TERMUX_PKG_DESCRIPTION="Library for file management"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pcmanfm/libfm-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=a5042630304cf8e5d8cff9d565c6bd546f228b48c960153ed366a34e87cad1e5
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libandroid-support, libcairo, libexif, libffi, menu-cache, pango, pcre"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gtk=3"

# Avoid conflict with libfm-extra-static which already ships these
TERMUX_PKG_RM_AFTER_INSTALL="
lib/libfm-extra.a
lib/libfm-extra.la
"

TERMUX_PKG_CONFLICTS="libfm-extra"
TERMUX_PKG_REPLACES="libfm-extra"
TERMUX_PKG_PROVIDES="libfm-extra (= $TERMUX_PKG_VERSION)"

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(curl --silent --location 'https://sourceforge.net/projects/pcmanfm/files/PCManFM%20%2B%20Libfm%20%28tarball%20release%29/LibFM/' | grep -oP 'libfm-\K[0-9]+(\.[0-9]+)+(?=\.tar\.xz)' | sort -V | tail -n1)"

	if [[ -z "${latest_version}" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}
