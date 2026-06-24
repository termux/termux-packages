TERMUX_PKG_HOMEPAGE=https://github.com/ScriptsSoftware/zxas-editor
TERMUX_PKG_DESCRIPTION="ZXAS code editor for Termux/Linux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_SRCURL=https://github.com/ScriptsSoftware/zxas-editor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="nodejs"

termux_step_make_install() {
    mkdir -p $TERMUX_PREFIX/lib/node_modules/zxas

    cp -r ./* $TERMUX_PREFIX/lib/node_modules/zxas/

    cat > $TERMUX_PREFIX/bin/zxas <<-EOF
#!/data/data/com.termux/files/usr/bin/sh
node $TERMUX_PREFIX/lib/node_modules/zxas/index.js "\$@"
EOF

    chmod +x $TERMUX_PREFIX/bin/zxas
}
# ZXAS package
