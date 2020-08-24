TERMUX_PKG_HOMEPAGE=https://www.wireguard.com
TERMUX_PKG_DESCRIPTION="Tools for the WireGuard secure network tunnel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.0.20200820
TERMUX_PKG_SRCURL=https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=7735a04c68fffb101a10a67e3bd97a171f2b8eb47e9ddce2be68eb6538b013d0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src WITH_BASHCOMPLETION=yes WITH_WGQUICK=no WITH_SYSTEMDUNITS=no"

termux_step_post_make_install() {
	cd src/wg-quick
	$CC $CFLAGS $LDFLAGS -DWG_CONFIG_SEARCH_PATHS="\"$TERMUX_ANDROID_HOME/.wireguard $TERMUX_PREFIX/etc/wireguard /data/misc/wireguard /data/data/com.wireguard.android/files\"" -o wg-quick android.c
	install -Dm0700 wg-quick $TERMUX_PREFIX/bin/wg-quick
}
