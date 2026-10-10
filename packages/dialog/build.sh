TERMUX_PKG_HOMEPAGE=https://invisible-island.net/dialog/
TERMUX_PKG_DESCRIPTION="Application used in shell scripts which displays text user interface widgets"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_VERSION="1.3-20260721"
TERMUX_PKG_SRCURL="https://invisible-island.net/archives/dialog/dialog-${TERMUX_PKG_VERSION}.tgz"
TERMUX_PKG_SHA256=62bdf59057d4f760a1cc2217827f07887b4a3eebf694c25eacd4803d2171cdc6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ncursesw
--enable-widec
--with-pkg-config
"

termux_pkg_auto_update() {
	local latest_version="$(curl --silent \
		https://invisible-island.net/datafiles/release/dialog.tar.gz | \
		tar --exclude='*/*' -tz | \
		sed 's|dialog-\(.*\)/|\1|')"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	# Put a temporary link for libtinfo.so
	ln -sf "$TERMUX_PREFIX/lib/libncursesw.so" "$TERMUX_PREFIX/lib/libtinfo.so"
}

termux_step_post_make_install() {
	rm "$TERMUX_PREFIX/lib/libtinfo.so"
}
