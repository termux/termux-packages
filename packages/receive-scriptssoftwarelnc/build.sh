TERMUX_PKG_HOMEPAGE=https://github.com/ScriptsSoftware/receive-scriptssoftwarelnc-1.0.3-funcions
TERMUX_PKG_DESCRIPTION="Express data receiver"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL=https://github.com/ScriptsSoftware/receive-scriptssoftwarelnc-1.0.3-funcions/archive/refs/tags/v2.1.0.tar.gz

termux_step_make_install() {
    mkdir -p $TERMUX_PREFIX/lib/node_modules/receive-scriptssoftwarelnc
    cp -r "$TERMUX_PKG_SRCDIR"/* $TERMUX_PREFIX/lib/node_modules/receive-scriptssoftwarelnc/
}
