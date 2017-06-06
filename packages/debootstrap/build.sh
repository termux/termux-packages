TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/Debootstrap
TERMUX_PKG_DESCRIPTION="Bootstrap a basic Debian system"
TERMUX_PKG_VERSION=1.0.90
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/d/debootstrap/debootstrap_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4d1f434b093051a27fe9482063e2b09aa88cdcc51877228b04729e302ba9145e
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="wget, proot"
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"

termux_step_post_make_install() {
    mkdir -p ${TERMUX_PREFIX}/share/man/man8/
    install ${TERMUX_PKG_SRCDIR}/debootstrap.8 ${TERMUX_PREFIX}/share/man/man8/
}
