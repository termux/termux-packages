TERMUX_PKG_HOMEPAGE=http://www.thc.org/
TERMUX_PKG_DESCRIPTION="Secure file, disk, swap, memory erasure utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/s/secure-delete/secure-delete_$TERMUX_PKG_VERSION.orig.tar.gz
TERMUX_PKG_SHA256=78af201401e6dc159298cb5430c28996a8bdc278391d942d1fe454534540ee3c
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make -j1 CC="$CC"
}

termux_step_make_install() {
	make install INSTALL_DIR="$TERMUX_PREFIX/bin"
	install -Dm600 -t "$TERMUX_PREFIX"/share/man/man1 sfill.1 smem.1 srm.1 sswap.1
}
