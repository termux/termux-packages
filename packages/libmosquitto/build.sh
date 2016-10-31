TERMUX_PKG_DESCRIPTION="MQTT library"
TERMUX_PKG_HOMEPAGE=https://mosquitto.org/
TERMUX_PKG_VERSION=1.4.10
TERMUX_PKG_SRCURL=https://mosquitto.org/files/source/mosquitto-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=437648d68a4a781dd8d913814cd5451f59ab4a5fcf84cccaf7c36e6a07459770
TERMUX_PKG_BUILD_IN_SRC=Yes
TERMUX_PKG_DEPENDS="c-ares, openssl"
TERMUX_PKG_MAINTAINER="Nathaniel Wesley Filardo @nwf"

termux_step_make () {
  for i in lib client; do make -C $i; done
}
termux_step_make_install() {
  for i in lib client; do make -C $i DESTDIR=${TERMUX_PREFIX} install; done
}

