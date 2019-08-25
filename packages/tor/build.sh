TERMUX_PKG_HOMEPAGE=https://www.torproject.org
TERMUX_PKG_DESCRIPTION="The Onion Router anonymizing overlay network"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=0.4.1.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.torproject.org/dist/tor-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a864e0b605fb933fcc167bf242eed4233949e8a1bf23ac8e0381b106cd920425
TERMUX_PKG_DEPENDS="libevent, openssl, liblzma, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-zstd --disable-unittests"
TERMUX_PKG_CONFFILES="etc/tor/torrc var/service/tor/run var/service/tor/log/run"

termux_step_pre_configure() {
	export LIBS="-llog"
}

termux_step_post_make_install() {
	# use default config
	mv "$TERMUX_PREFIX/etc/tor/torrc.sample" "$TERMUX_PREFIX/etc/tor/torrc"

	# Setup tor service script
	mkdir -p $TERMUX_PREFIX/var/service
	cd $TERMUX_PREFIX/var/service
	mkdir -p tor/log
	echo "#!$TERMUX_PREFIX/bin/sh" > tor/run
	echo 'exec tor 2>&1' >> tor/run
	chmod +x tor/run
	touch tor/down
	ln -sf $TERMUX_PREFIX/share/termux-services/svlogger tor/log/run
}
