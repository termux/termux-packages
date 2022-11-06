TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/Debootstrap
TERMUX_PKG_DESCRIPTION="Bootstrap a basic Debian system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.127
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/d/debootstrap/debootstrap_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=45887cf0582e6d16598e50713278d16b2272d02bdd117a9876e98277300dabd4
TERMUX_PKG_DEPENDS="perl, proot, wget"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PREFIX}/share/man/man8/
	install ${TERMUX_PKG_SRCDIR}/debootstrap.8 ${TERMUX_PREFIX}/share/man/man8/
}
