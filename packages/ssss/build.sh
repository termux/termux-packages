TERMUX_PKG_HOMEPAGE=http://point-at-infinity.org/ssss/
TERMUX_PKG_DESCRIPTION="Simple command-line implementation of Shamir's Secret Sharing Scheme"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://point-at-infinity.org/ssss/ssss-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5d165555105606b8b08383e697fc48cf849f51d775f1d9a74817f5709db0f995
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 ssss-split "$TERMUX_PREFIX"/bin/
	ln -sfr "$TERMUX_PREFIX"/bin/ssss-split $TERMUX_PREFIX/bin/ssss-combine

	install -Dm600 \
		"$TERMUX_PKG_BUILDER_DIR"/ssss.1 \
		"$TERMUX_PREFIX"/share/man/man1/
	ln -sfr \
		"$TERMUX_PREFIX"/share/man/man1/ssss.1 \
		"$TERMUX_PREFIX"/share/man/man1/ssss-combine.1
	ln -sfr \
		"$TERMUX_PREFIX"/share/man/man1/ssss.1 \
		"$TERMUX_PREFIX"/share/man/man1/ssss-split.1
}
