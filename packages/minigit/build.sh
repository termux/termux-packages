TERMUX_PKG_HOMEPAGE="http://72.61.248.193:3800"
TERMUX_PKG_DESCRIPTION="A Git-compatible version control CLI for Mini GitHub platform"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="rahipatel1285 <rahul834757@gmail.com>"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL="https://registry.npmjs.org/minigithub-cli/-/minigithub-cli-${TERMUX_PKG_VERSION}.tgz"
TERMUX_PKG_SHA256="687d9eb0fc897c3a2474dd280d866bd663a3303019f9594c9ea0ef777caaa7da"
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    # Create required directories
    mkdir -p $TERMUX_PREFIX/lib/node_modules/minigithub-cli
    mkdir -p $TERMUX_PREFIX/bin

    # Copy files
    cp -r * $TERMUX_PREFIX/lib/node_modules/minigithub-cli/

    # Create the executable symlink
    ln -srf $TERMUX_PREFIX/lib/node_modules/minigithub-cli/dist/index.js $TERMUX_PREFIX/bin/minigit
    chmod +x $TERMUX_PREFIX/bin/minigit
}
