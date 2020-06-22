TERMUX_PKG_HOMEPAGE=https://github.com/ib/xarchiver
TERMUX_PKG_DESCRIPTION="GTK+ frontend to various command line archivers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.5.4.15
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ib/xarchiver/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2a18f5a8932516ecc5c50152ff6ce77bc3f58a0b221d6db9c70d089cf90d7182
TERMUX_PKG_DEPENDS="atk, binutils, bzip2, cpio, glib, gtk3, gzip, libandroid-shmem, libcairo, lzip, lzop, p7zip, tar, unrar, unzip, xz-utils, zip, zstd, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons/hicolor/icon-theme.cache"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem"
}
