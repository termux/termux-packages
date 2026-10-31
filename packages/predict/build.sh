TERMUX_PKG_HOMEPAGE=https://www.qsl.net/kd2bd/predict.html
TERMUX_PKG_DESCRIPTION="A Satellite Tracking/Orbital Prediction Program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.2
TERMUX_PKG_SRCURL=https://www.qsl.net/kd2bd/predict-${TERMUX_PKG_VERSION}-termux.tar.gz
TERMUX_PKG_SHA256=138ea80bd7f48a4ccbd493596e990ec53d8748462444e7ba4dbc610d12b6c7e8
TERMUX_PKG_DEPENDS="libcurl, ncurses, ncurses-ui-libs,play-audio"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	rm "${TERMUX_PKG_SRCDIR}/configure"
}

# shellcheck disable=SC2086 # We actually want word splitting on those variables
termux_step_make() {
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -Wall -Wno-deprecated-non-prototype \
		-DBUILD_DIR="\"$TERMUX_PREFIX/opt/predict/\"" -DPREDICT_VERSION="\"$(cat .version)\"" \
		predict.c -lm -lncurses -lcurl -o predict
}

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX"/opt/predict

	install -Dm700 predict "$TERMUX_PREFIX"/opt/predict/predict
	cp -r ./default "$TERMUX_PREFIX"/opt/predict/
	cp -r ./vocalizer "$TERMUX_PREFIX"/opt/predict/

	gzip -c "$PWD"/docs/man/predict.1 > "$TERMUX_PREFIX"/share/man/man1/predict.1.gz

	ln -sfr "$TERMUX_PREFIX"/opt/predict/predict "$TERMUX_PREFIX"/bin/predict
}
