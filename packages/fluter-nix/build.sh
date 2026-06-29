TERMUX_PKG_HOMEPAGE=https://github.com/ScriptsSoftware/fluter-nix
TERMUX_PKG_DESCRIPTION="Cliente HTTP para Termux usando curl"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_DEPENDS="curl"
TERMUX_PKG_SRCURL=https://github.com/ScriptsSoftware/fluter-nix/archive/refs/tags/v1.0.2.tar.gz

termux_step_make_install() {
    install -Dm755 "$TERMUX_PKG_SRCDIR/fluter" "$TERMUX_PREFIX/bin/fluter"
}
