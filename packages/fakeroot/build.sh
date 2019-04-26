TERMUX_PKG_HOMEPAGE=http://packages.debian.org/fakeroot
TERMUX_PKG_DESCRIPTION="Tool for simulating superuser privileges (with tcp ipc)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=1.23
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=009cd6696a931562cf1c212bb57ca441a4a2d45cd32c3190a35c7ae98506f4f6
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ipc=tcp"
TERMUX_PKG_BUILD_DEPENDS="libcap-dev"

termux_step_post_make_install() {
	ln -sfr "${TERMUX_PREFIX}/lib/libfakeroot-0.so" "${TERMUX_PREFIX}/lib/libfakeroot.so"
}
