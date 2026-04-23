TERMUX_PKG_HOMEPAGE=https://github.com/hastagaming/GlobPack
TERMUX_PKG_DESCRIPTION="A community-driven global package manager for terminals"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Nasa <hastagaming@github>"
TERMUX_PKG_VERSION=1.0.0
# This URL points to your GitHub Release
TERMUX_PKG_SRCURL=https://github.com/hastagaming/GlobPack/archive/refs/tags/v1.0.0.tar.gz
# Generate this using 'sha256sum' after you download the tar.gz
TERMUX_PKG_SHA256=70b1cc3968a3421831579fc5399a5a45693f385b7283186c357c7aa3f2871537 v1.0.0.tar.gz
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    # Move the 'gp' binary to the system path
    install -Dm755 $TERMUX_PKG_SRCDIR/bin/gp $TERMUX_PREFIX/bin/gp

    # Create the registry directory in the system share folder
    mkdir -p $TERMUX_PREFIX/share/globpack
    touch $TERMUX_PREFIX/share/globpack/.gitkeep
}
