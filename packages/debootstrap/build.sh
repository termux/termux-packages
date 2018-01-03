TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/Debootstrap
TERMUX_PKG_DESCRIPTION="Bootstrap a basic Debian system"
TERMUX_PKG_VERSION=1.0.93
TERMUX_PKG_SHA256=cdad4d2be155bd933acbe4f3479e1765e5f4447fb50564e30e33f7b3b84bd7db
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/d/debootstrap/debootstrap_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="wget, proot, perl"
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_post_make_install() {
    mkdir -p ${TERMUX_PREFIX}/share/man/man8/
    install ${TERMUX_PKG_SRCDIR}/debootstrap.8 ${TERMUX_PREFIX}/share/man/man8/
}
