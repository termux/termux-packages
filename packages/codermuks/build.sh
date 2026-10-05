TERMUX_PKG_HOMEPAGE=https://github.com/mixailneAI/Codermuks-in-termux
TERMUX_PKG_DESCRIPTION="AI coding agent for Termux powered by Mistral"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@mixailneAI"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=https://github.com/mixailneAI/Codermuks-in-termux/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bfc6403ce4dc670e24e79840b895a1d49ebd9f5e50d93396ed47d47859945d51
TERMUX_PKG_DEPENDS="python, python-pip, clang, rust, golang, openjdk-17, git, binutils, make"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    mkdir -p "$TERMUX_PREFIX/share/codermuks"
    cp -r "$TERMUX_PKG_SRCDIR"/* "$TERMUX_PREFIX/share/codermuks/"

    pip install --no-deps --target="$TERMUX_PREFIX/share/codermuks" \
        mistralai rich requests pyfiglet

    cat > "$TERMUX_PREFIX/bin/codermuks" <<EOF
#!$TERMUX_PREFIX/bin/bash
exec python "$TERMUX_PREFIX/share/codermuks/main.py" "\$@"
EOF
    chmod +x "$TERMUX_PREFIX/bin/codermuks"
}
