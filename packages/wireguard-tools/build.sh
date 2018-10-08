TERMUX_PKG_HOMEPAGE=https://www.wireguard.com
TERMUX_PKG_DESCRIPTION="Tools for the WireGuard secure network tunnel"
TERMUX_PKG_VERSION=0.0.20181007
TERMUX_PKG_SHA256=d26e0d1216594871b5947e76d64c2fa50e9b34b68cdcfa3fdad588cbb314af89
TERMUX_PKG_SRCURL=https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libmnl, tsu"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src/tools WITH_BASHCOMPLETION=yes WITH_WGQUICK=no WITH_SYSTEMDUNITS=no"

termux_step_post_make_install () {
    cd src/tools/wg-quick
    $CC $CFLAGS -DWG_CONFIG_SEARCH_PATHS="\"$TERMUX_ANDROID_HOME/.wireguard $TERMUX_PREFIX/etc/wireguard /data/misc/wireguard /data/data/com.wireguard.android/files\"" -o wg-quick android.c
    install -m 0755 wg-quick $TERMUX_PREFIX/bin
}
