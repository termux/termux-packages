TERMUX_PKG_HOMEPAGE=https://www.wireguard.com
TERMUX_PKG_DESCRIPTION="Tools for the WireGuard secure network tunnel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.20210914
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=942ed32d1d6631932c82ff86c91ae8428d4c90bfec231a14ebdf6c29f068e60b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src WITH_BASHCOMPLETION=yes WITH_WGQUICK=no WITH_SYSTEMDUNITS=no"

termux_step_post_make_install() {
	cd src/wg-quick
	$CC $CFLAGS $LDFLAGS -DWG_CONFIG_SEARCH_PATHS="\"$TERMUX_ANDROID_HOME/.wireguard $TERMUX_PREFIX/etc/wireguard /data/misc/wireguard /data/data/com.wireguard.android/files\"" -o wg-quick android.c
	install -Dm0700 wg-quick $TERMUX_PREFIX/bin/wg-quick
}
