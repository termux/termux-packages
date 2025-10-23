TERMUX_PKG_HOMEPAGE=https://github.com/v1cont/yad
TERMUX_PKG_DESCRIPTION="Display graphical dialogs from shell scripts or command line"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=14.1
TERMUX_PKG_SRCURL=https://github.com/v1cont/yad/releases/download/v${TERMUX_PKG_VERSION}/yad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=dde047a915cd8d3892c32b6ba031876f5cda673e01882c99613f043867c88133
TERMUX_PKG_DEPENDS="gspell, gtk3, gtksourceview3, libandroid-shmem, webkit2gtk-4.1"
TERMUX_PKG_BUILD_DEPENDS="libxml2-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-shmem"
}
