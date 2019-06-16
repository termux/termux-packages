TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/barcode/
TERMUX_PKG_DESCRIPTION="Tool to convert text strings to printed bars"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.99
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://mirrors.kernel.org/gnu/barcode/barcode-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=e87ecf6421573e17ce35879db8328617795258650831affd025fba42f155cdc6
TERMUX_PKG_BUILD_DEPENDS="gettext"

termux_step_pre_configure() {
	CPPFLAGS+=" -I$TERMUX_PREFIX/share/gettext"
}
