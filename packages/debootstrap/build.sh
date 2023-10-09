TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/Debootstrap
TERMUX_PKG_DESCRIPTION="Bootstrap a basic Debian system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="debian/copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.132"
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/d/debootstrap/debootstrap_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d963a465314ac0e8fd5392573def042e6663e8edf3d08ace4bbd0d27ee8431f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="binutils | binutils-is-llvm, perl, proot, sed, wget"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PREFIX}/share/man/man8/
	install ${TERMUX_PKG_SRCDIR}/debootstrap.8 ${TERMUX_PREFIX}/share/man/man8/
}

termux_step_post_massage() {
	rm -f ./share/debootstrap/scripts/*.orig
}
