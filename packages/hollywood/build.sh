TERMUX_PKG_HOMEPAGE=https://launchpad.net/hollywood
TERMUX_PKG_DESCRIPTION="Fill your console with Hollywood melodrama technobabble"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.25"
TERMUX_PKG_SRCURL=https://github.com/dustinkirkland/hollywood/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6eb1509ad1a19a2b475ecc09c4199017cc3fafbfb7fa990fe5ec408367f83962
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bmon, byobu, cmatrix, coreutils, dash, gawk, htop, mandoc, tree, util-linux"
TERMUX_PKG_RECOMMENDS="apg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -dm0700 "$TERMUX_PREFIX"/{bin,lib/hollywood,share/{man/man1,hollywood}}
	install -m 0700 "$TERMUX_PKG_SRCDIR"/bin/hollywood  "$TERMUX_PREFIX"/bin/
	install -m 0700 "$TERMUX_PKG_SRCDIR"/lib/hollywood/* "$TERMUX_PREFIX"/lib/hollywood/
	install -m 0600 "$TERMUX_PKG_SRCDIR"/share/hollywood/*  "$TERMUX_PREFIX"/share/hollywood/
	install -m 0600 "$TERMUX_PKG_SRCDIR"/share/man/man1/*  "$TERMUX_PREFIX"/share/man/man1/
}
