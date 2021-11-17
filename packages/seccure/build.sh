TERMUX_PKG_HOMEPAGE=http://point-at-infinity.org/seccure/
TERMUX_PKG_DESCRIPTION="SECCURE Elliptic Curve Crypto Utility for Reliable Encryption"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=http://point-at-infinity.org/seccure/seccure-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6566ce4afea095f83690b93078b910ca5b57b581ebc60e722f6e3fe8e098965b
TERMUX_PKG_DEPENDS="libgcrypt"
TERMUX_PKG_EXTRA_MAKE_ARGS="seccure-key"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/share/man/man1/
	install -Dm700 seccure-key "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/bin/
	install -Dm600 seccure.1 \
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/share/man/man1/

	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
	for prog in encrypt decrypt sign verify signcrypt veridec dh; do
		ln -sfr seccure-key bin/seccure-${prog}
		ln -sfr seccure.1 share/man/man1/seccure-${prog}.1
	done
}
