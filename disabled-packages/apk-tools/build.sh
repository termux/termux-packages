TERMUX_PKG_HOMEPAGE=https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
TERMUX_PKG_DESCRIPTION="Alpine Linux package management tools"
TERMUX_PKG_VERSION=2.10.1
TERMUX_PKG_SHA256=278854c4ee21ed4ddb7605ef09190385106c6fdfc10526e32e0108ad0f12509a
TERMUX_PKG_SRCURL=https://github.com/alpinelinux/apk-tools/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="LUAAPK="

termux_step_post_make_install() {
    mkdir -p $TERMUX_PREFIX/etc/apk/
    echo $TERMUX_ARCH > $TERMUX_PREFIX/etc/apk/arch

    mkdir -p $TERMUX_PREFIX/lib/apk/db/
    echo "Needed by the apk tool." > $TERMUX_PREFIX/lib/apk/db/README
}

