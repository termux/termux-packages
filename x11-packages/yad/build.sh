TERMUX_PKG_HOMEPAGE=https://github.com/v1cont/yad
TERMUX_PKG_DESCRIPTION="Display graphical dialogs from shell scripts or command line"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="14.2"
TERMUX_PKG_SRCURL=https://github.com/v1cont/yad/releases/download/v${TERMUX_PKG_VERSION}/yad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5cab399af8d9a10b76d477f848180d00addba38f4f1272a05b153a393bba3038
TERMUX_PKG_DEPENDS="gspell, gtk3, gtksourceview3, libandroid-shmem, webkit2gtk-4.1"
TERMUX_PKG_BUILD_DEPENDS="libxml2-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-shmem"
}
