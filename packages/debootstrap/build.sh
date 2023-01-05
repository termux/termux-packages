TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/Debootstrap
TERMUX_PKG_DESCRIPTION="Bootstrap a basic Debian system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="debian/copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.128+nmu2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/d/debootstrap/debootstrap_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=528523228d93a31c9e0cd4eb932977ea8ceec2bfbf8db1103bec2397cc7434fa
TERMUX_PKG_DEPENDS="binutils, perl, proot, wget"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PREFIX}/share/man/man8/
	install ${TERMUX_PKG_SRCDIR}/debootstrap.8 ${TERMUX_PREFIX}/share/man/man8/
}

termux_step_post_massage() {
	rm -f ./share/debootstrap/scripts/*.orig
}
