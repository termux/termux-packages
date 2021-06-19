TERMUX_PKG_HOMEPAGE=https://www.yoctoproject.org/software-item/matchbox/
TERMUX_PKG_DESCRIPTION="An on-screen virtual keyboard."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.1.1
TERMUX_PKG_REVISION=26
TERMUX_PKG_SRCURL=https://git.yoctoproject.org/cgit/cgit.cgi/matchbox-keyboard/snapshot/matchbox-keyboard-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=44fc6dc6075090d6f8e43f8667cf8a85bed59b7221a5ee81843454c66e352790
TERMUX_PKG_DEPENDS="libexpat, libfakekey, libpng, libx11, libxft, libxrender, libxtst, zlib"
TERMUX_PKG_RECOMMENDS="ttf-dejavu"

termux_step_pre_configure() {
	autoreconf -i
}
