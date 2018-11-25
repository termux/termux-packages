TERMUX_PKG_HOMEPAGE=https://github.com/xeffyr/libandroid-shmem-x11
TERMUX_PKG_DESCRIPTION="Shared memory functionality for Termux (x11 packages)"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=https://github.com/xeffyr/libandroid-shmem-x11/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea032e8b68a6815de0286408043b67c1c472887c66835634cf13729a83f7cf3f
TERMUX_PKG_BUILD_IN_SRC=yes

## Completely replaces libandroid-shmem.
TERMUX_PKG_PROVIDES="libandroid-shmem"
TERMUX_PKG_REPLACES="${TERMUX_PKG_PROVIDES}"
TERMUX_PKG_CONFLICTS="${TERMUX_PKG_PROVIDES}, libandroid-shmem-dev"
