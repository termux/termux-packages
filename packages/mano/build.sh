TERMUX_PKG_HOMEPAGE=https://github.com/46Neon/Mano_versi-n_c
TERMUX_PKG_DESCRIPTION="Spanish-language data analysis tool for occupational safety and health statistics and preventive analysis"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@46Neon"
TERMUX_PKG_VERSION=0.1.1
TERMUX_PKG_SRCURL=https://codeload.github.com/46Neon/Mano_versi-n_c/legacy.tar.gz/refs/tags/v0.1.1
TERMUX_PKG_SHA256=e79fa9b949ba81ac6f4f87a3951d36f93e331b246e5290aab62dc6e0dd214450
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    make CC="$CC"
}

termux_step_make_install() {
    install -Dm755 mano "$TERMUX_PREFIX/bin/mano"
    install -Dm644 README.md "$TERMUX_PREFIX/share/doc/mano/README.md"
    mkdir -p "$TERMUX_PREFIX/share/doc/mano/examples"
    cp -R examples/. "$TERMUX_PREFIX/share/doc/mano/examples/"
}
