TERMUX_PKG_HOMEPAGE=https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
TERMUX_PKG_DESCRIPTION="Alpine Linux package management tools"
TERMUX_PKG_VERSION=2.10.3
TERMUX_PKG_SHA256=f91861ed981d0a2912d5d860a33795ec40d16021ab03f6561a3849b9c0bcf77e
TERMUX_PKG_SRCURL=https://github.com/alpinelinux/apk-tools/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="LUAAPK="
TERMUX_PKG_CONFFILES="etc/apk/repositories"

termux_step_post_make_install() {
    mkdir -p $TERMUX_PREFIX/etc/apk/
    echo $TERMUX_ARCH > $TERMUX_PREFIX/etc/apk/arch

    mkdir -p $TERMUX_PREFIX/lib/apk/db/
    echo "Needed by the apk tool." > $TERMUX_PREFIX/lib/apk/db/README

    echo "https://termux.net/apk/main" > $TERMUX_PREFIX/etc/apk/repositories
}

