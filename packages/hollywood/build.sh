TERMUX_PKG_HOMEPAGE=https://launchpad.net/hollywood
TERMUX_PKG_DESCRIPTION="Fill your console with Hollywood melodrama technobabble"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.20
TERMUX_PKG_SRCURL=https://launchpad.net/hollywood/trunk/${TERMUX_PKG_VERSION}/+download/hollywood_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=5d6d366ab7e2fd15833f6d2fbd390e39deecf516f04710d3fee9662169f94677
TERMUX_PKG_DEPENDS="apg, bmon, byobu, cmatrix, coreutils, dash, gawk, htop, man, tree, util-linux"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -dm0700 "$TERMUX_PREFIX"/{bin,lib/hollywood,share/{man/man1,hollywood}}
	install -m 0700 "$TERMUX_PKG_SRCDIR"/bin/hollywood  "$TERMUX_PREFIX"/bin/
	install -m 0700 "$TERMUX_PKG_SRCDIR"/lib/hollywood/* "$TERMUX_PREFIX"/lib/hollywood/
	install -m 0600 "$TERMUX_PKG_SRCDIR"/share/hollywood/*  "$TERMUX_PREFIX"/share/hollywood/
	install -m 0600 "$TERMUX_PKG_SRCDIR"/share/man/man1/*  "$TERMUX_PREFIX"/share/man/man1/
}
