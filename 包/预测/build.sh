TERMUX_PKG_HOMEPAGE=https://qsl.net/kd2bd/predict.html
TERMUX_PKG_DESCRIPTION="Satellite tracking, orbital prediction"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.7
TERMUX_PKG_SRCURL=https://qsl.net/kd2bd/predict-${TERMUX_PKG_VERSION}-termux.tar.gz
TERMUX_PKG_SHA256=b5e454c13818a4c2dcb1e2146352f41d806a76cfa85410cb5e93d02a458f60a9
TERMUX_PKG_DEPENDS="libllvm,ncurses,man,play-audio,termux-api,wget"

termux_step_pre_configure() {
    mkdir -p $TERMUX_PREFIX/opt/predict
    echo ${TERMUX_PKG_VERSION} > $TERMUX_PREFIX/opt/predict/.version
}

termux_step_post_configure() {
    cp -ar * $TERMUX_PREFIX/opt/predict
}
