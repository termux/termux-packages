TERMUX_PKG_HOMEPAGE=https://sleuthkit.org/
TERMUX_PKG_DESCRIPTION="The Sleuth Kit® (TSK) is a library for digital forensics tools. "
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="licenses/README.md, licenses/GNUv2-COPYING, licenses/GNUv3-COPYING, licenses/IBM-LICENSE, licenses/Apache-LICENSE-2.0.txt, licenses/cpl1.0.txt, licenses/bsd.txt, licenses/mit.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.15.0"
TERMUX_PKG_SRCURL=https://github.com/sleuthkit/sleuthkit/archive/refs/tags/sleuthkit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4888ef54f9b404853712945218b3168696569db9167d7e01ec76e44b6c05c71c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libsqlite, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-java"

termux_step_pre_configure() {
	./bootstrap
}
