TERMUX_PKG_HOMEPAGE=https://www.wireguard.com
TERMUX_PKG_DESCRIPTION="Tools for the WireGuard secure network tunnel"
TERMUX_PKG_VERSION=0.0.20171101
TERMUX_PKG_SRCURL=https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=096b6482a65e566c7bf8c059f5ee6aadb2de565b04b6d810c685f1c377540325
TERMUX_PKG_DEPENDS="libmnl"

termux_step_make() {
  make -C src/tools
}

termux_step_make_install() {
  make -C src/tools PREFIX=$TERMUX_PREFIX
}
