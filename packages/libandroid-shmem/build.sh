TERMUX_PKG_HOMEPAGE=https://github.com/termux/libandroid-shmem
TERMUX_PKG_DESCRIPTION="System V shared memory emulation on Android using ashmem"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/termux/libandroid-shmem/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8d161993260d7bd4f35956c5a302a1edd9fe5b9fd1a239d8e721b2746ab0920d
TERMUX_PKG_BREAKS="libandroid-shmem-dev"
TERMUX_PKG_REPLACES="libandroid-shmem-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local _PATCH_FILE="libandroid-shmem-0.3-libc-symbols.patch"
	termux_download \
		"https://github.com/termux/libandroid-shmem/pull/12/commits/e64c4e4cdab3a551260f3a82bf98bebc58d4bd9e.patch" \
		$TERMUX_PKG_CACHEDIR/${_PATCH_FILE} \
		db7709f2e9d0ba9556c103ae7d604c684ac8a7f23154c3ddca9f36ed54b99306
	cat $TERMUX_PKG_CACHEDIR/${_PATCH_FILE} | patch --silent -p1
}
