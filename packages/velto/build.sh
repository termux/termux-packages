TERMUX_PKG_HOMEPAGE=https://github.com/rishu132024-create/velto
TERMUX_PKG_DESCRIPTION="Velto programming language"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Rishu132024-create"
TERMUX_PKG_VERSION=0.87.2
TERMUX_PKG_SRCURL=https://github.com/rishu132024-create/velto/archive/refs/tags/v0.87.2.tar.gz
TERMUX_PKG_DEPENDS="python"

termux_step_make_install() {
    mkdir -p "$TERMUX_PREFIX/lib/velto"
    mkdir -p "$TERMUX_PREFIX/bin"

    cp -r ./* "$TERMUX_PREFIX/lib/velto/"

    cat > "$TERMUX_PREFIX/bin/velto" <<'SCRIPT'
#!/data/data/com.termux/files/usr/bin/bash
exec python "$PREFIX/lib/velto/velto_cli.py" "$@"
SCRIPT

    chmod 755 "$TERMUX_PREFIX/bin/velto"
}
