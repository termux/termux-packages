TERMUX_PKG_HOMEPAGE=https://sleuthkit.org/
TERMUX_PKG_DESCRIPTION="The Sleuth Kit® (TSK) is a library for digital forensics tools. "
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="licenses/README.md, licenses/GNUv2-COPYING, licenses/GNUv3-COPYING, licenses/IBM-LICENSE, licenses/Apache-LICENSE-2.0.txt, licenses/cpl1.0.txt, licenses/bsd.txt, licenses/mit.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.12.0
TERMUX_PKG_SRCURL=https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0ca819723b08620e60e97083dc1727d3b6ab69b75b2b0eb421c27d6a0e0e5b57
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libsqlite, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-java"

termux_step_pre_configure() {
	./bootstrap
}
