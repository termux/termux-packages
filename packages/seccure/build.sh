TERMUX_PKG_HOMEPAGE=http://point-at-infinity.org/seccure/
TERMUX_PKG_DESCRIPTION="SECCURE Elliptic Curve Crypto Utility for Reliable Encryption"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=http://point-at-infinity.org/seccure/seccure-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6566ce4afea095f83690b93078b910ca5b57b581ebc60e722f6e3fe8e098965b
TERMUX_PKG_DEPENDS="libgcrypt"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make seccure-key
}

termux_step_make_install() {
	install -Dm700 seccure-key "$TERMUX_PREFIX"/bin/
	install -Dm600 seccure.1 "$TERMUX_PREFIX"/share/man/man1/

	for i in encrypt decrypt sign verify signcrypt veridec dh; do
		ln -sfr "$TERMUX_PREFIX"/bin/seccure-key "$TERMUX_PREFIX"/bin/seccure-${i}
		ln -sfr "$TERMUX_PREFIX"/share/man/man1/seccure.1 "$TERMUX_PREFIX"/share/man/man1/seccure-${i}.1
	done
	unset i
}
