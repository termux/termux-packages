TERMUX_PKG_HOMEPAGE=https://www.libraw.org
TERMUX_PKG_DESCRIPTION="A library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others"
TERMUX_PKG_LICENSE="LGPL-2.1, CDDL-1.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.21.1
TERMUX_PKG_SRCURL=https://www.libraw.org/data/LibRaw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=630a6bcf5e65d1b1b40cdb8608bdb922316759bfb981c65091fec8682d1543cd
TERMUX_PKG_DEPENDS="littlecms, libjasper"

termux_step_pre_configure() {
    LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
