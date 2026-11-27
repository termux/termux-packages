TERMUX_PKG_HOMEPAGE=https://invisible-island.net/dialog/
TERMUX_PKG_DESCRIPTION="Application used in shell scripts which displays text user interface widgets"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_VERSION="1.3-20260721"
TERMUX_PKG_SRCURL="https://invisible-mirror.net/archives/dialog/dialog-${TERMUX_PKG_VERSION}.tgz"
TERMUX_PKG_SHA256=62bdf59057d4f760a1cc2217827f07887b4a3eebf694c25eacd4803d2171cdc6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ncursesw
--enable-widec
--with-pkg-config
"

termux_pkg_auto_update() {
	local latest_version="$(curl --silent --fail --retry 3 --retry-all-errors \
		https://invisible-mirror.net/archives/dialog/ | \
		grep -oP 'dialog-\K[0-9][^"<]*(?=\.tgz)' | sort -uV | tail -n 1)"
	[[ -n "${latest_version}" ]] || termux_error_exit "Unable to get the latest version from https://invisible-mirror.net/archives/dialog/"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	# Put a temporary link for libtinfo.so
	ln -sf "$TERMUX_PREFIX/lib/libncursesw.so" "$TERMUX_PREFIX/lib/libtinfo.so"
}

termux_step_post_make_install() {
	rm "$TERMUX_PREFIX/lib/libtinfo.so"
}
