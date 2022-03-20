TERMUX_PKG_HOMEPAGE=https://github.com/strukturag/libheif
TERMUX_PKG_DESCRIPTION="HEIF (HEIC/AVIF) image encoding and decoding library"
TERMUX_PKG_LICENSE="LGPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/strukturag/libheif/releases/download/v${TERMUX_PKG_VERSION}/libheif-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e1ac2abb354fdc8ccdca71363ebad7503ad731c84022cf460837f0839e171718
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libaom, libc++, libdav1d, librav1e, libde265, libx265"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
