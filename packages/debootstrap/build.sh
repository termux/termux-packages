TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/Debootstrap
TERMUX_PKG_DESCRIPTION="Bootstrap a basic Debian system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.0.121
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/d/debootstrap/debootstrap_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c32e0f18c393c1f0ba8fa80768cb3e2669978aef71bd8e5c9aaf9902ba2e9e84
TERMUX_PKG_DEPENDS="wget, proot, perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
    mkdir -p ${TERMUX_PREFIX}/share/man/man8/
    install ${TERMUX_PKG_SRCDIR}/debootstrap.8 ${TERMUX_PREFIX}/share/man/man8/
}
