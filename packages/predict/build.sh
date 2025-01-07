TERMUX_PKG_HOMEPAGE=https://www.qsl.net/kd2bd/predict.html
TERMUX_PKG_DESCRIPTION="A Satellite Tracking/Orbital Prediction Program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.qsl.net/kd2bd/predict-${TERMUX_PKG_VERSION}-termux.tar.gz
TERMUX_PKG_SHA256=6eecccb21117e6ae57941659ac5d1d5f8cf99103ec8448e4fd8c076620bbd77b
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs,play-audio,wget"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	rm ${TERMUX_PKG_SRCDIR}/configure
}

termux_step_make() {
	echo "char *predictpath={\"$TERMUX_PREFIX/opt/predict/\"}, soundcard=1, *version={\"$(cat .version)\"};" > predict.h
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -Wall -Wno-deprecated-non-prototype predict.c -lm -lncurses -o predict
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/opt/predict
	
	install -Dm700 predict "$TERMUX_PREFIX"/opt/predict/predict
	install -Dm700 kepupdate "$TERMUX_PREFIX"/opt/predict/kepupdate
	cp -r ./default "$TERMUX_PREFIX"/opt/predict/
	cp -r ./vocalizer "$TERMUX_PREFIX"/opt/predict/

	gzip -c "$PWD"/docs/man/predict.1 > "$TERMUX_PREFIX"/share/man/man1/predict.1.gz

	ln -sfr "$TERMUX_PREFIX"/opt/predict/predict $TERMUX_PREFIX/bin/predict
	ln -sfr "$TERMUX_PREFIX"/opt/predict/kepupdate $TERMUX_PREFIX/bin/kepupdate
}
