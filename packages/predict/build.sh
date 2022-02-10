TERMUX_PKG_HOMEPAGE=https://www.qsl.net/kd2bd/predict.html
TERMUX_PKG_DESCRIPTION="Satellite tracking, orbital prediction."
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.7
TERMUX_PKG_SRCURL=https://www.qsl.net/kd2bd/predict-${TERMUX_PKG_VERSION}-termux.tar.gz
TERMUX_PKG_SHA256=b5e454c13818a4c2dcb1e2146352f41d806a76cfa85410cb5e93d02a458f60a9
TERMUX_PKG_DEPENDS="man,play-audio"

termux_step_post_configure() {
	mkdir -p $TERMUX_PREFIX/opt/predict
	mv default $TERMUX_PREFIX/opt/predict
	mv predict $TERMUX_PREFIX/opt/predict
	mv vocalizer $TERMUX_PREFIX/opt/predict
	mv docs $TERMUX_PREFIX/opt/predict
	mv kepupdate $TERMUX_PREFIX/opt/predict
	rm $TERMUX_PREFIX/bin/kepupdate
	ln -s $TERMUX_PREFIX/opt/predict/kepupdate $TERMUX_PREFIX/bin/
	ln -s $TERMUX_PREFIX/opt/predict/predict $TERMUX_PREFIX/bin/
}
