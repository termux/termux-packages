TERMUX_PKG_HOMEPAGE=https://github.com/senyyds12345/addon
TERMUX_PKG_DESCRIPTION="Tool for creating/building Minecraft Bedrock MCADDON, exclusive for Termux Android/Linux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="senyyds <1494621359@qq.com>"
TERMUX_PKG_VERSION="1.1.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/senyyds12345/addon/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256="e2c3ece7a8eb9ea8b9e76467800e8908951df3d7ff0a02fb03ad94abbc752f33"
TERMUX_PKG_DEPENDS="util-linux, jq, zip, python"
TERMUX_PKG_ARCHS="all"
TERMUX_PKG_SECTION="utils"
TERMUX_PKG_PRIORITY="optional"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 addon $TERMUX_PREFIX/bin/addon
    mkdir -p $TERMUX_PREFIX/addon
    cp -r ai $TERMUX_PREFIX/addon/
    cp -r SQL $TERMUX_PREFIX/addon/
}
