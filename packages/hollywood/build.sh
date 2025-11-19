TERMUX_PKG_HOMEPAGE=https://launchpad.net/hollywood
TERMUX_PKG_DESCRIPTION="Fill your console with Hollywood melodrama technobabble"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22"
TERMUX_PKG_REVISION=1
COMMIT="35275a68c37bbc39d8b2b0e4664a0c2f5451e5f6"
TERMUX_PKG_SRCURL=https://github.com/dustinkirkland/hollywood/archive/${COMMIT}.tar.gz
TERMUX_PKG_SHA256=7eab1994b4320ee8b3de751465082aed1f5fd12a8d8082ef749ed1249ea0b583
TERMUX_PKG_AUTO_UPDATE=false
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
