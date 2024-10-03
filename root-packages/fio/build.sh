TERMUX_PKG_HOMEPAGE=https://github.com/axboe/fio
TERMUX_PKG_DESCRIPTION="Flexible I/O Tester"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.38"
TERMUX_PKG_SRCURL=https://github.com/axboe/fio/archive/refs/tags/fio-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73b3ca18a66fb88a90dae73b9994fdd18d35161d914ffe2089380760af5533cf
TERMUX_PKG_DEPENDS="openssl, libandroid-shmem, libaio"
TERMUX_PKG_SUGGESTS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"

termux_pkg_auto_update() {
	local tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"
	if grep -qP "^fio-${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not stable release($tag)"
	fi
}

termux_step_pre_configure() {
	sed -i "s/@VERSION@/${TERMUX_PKG_VERSION}/g" $TERMUX_PKG_SRCDIR/Makefile
}
