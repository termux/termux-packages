TERMUX_PKG_HOMEPAGE=https://sleuthkit.org/
TERMUX_PKG_DESCRIPTION="The Sleuth Kit® (TSK) is a library for digital forensics tools. "
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="licenses/mit.txt, licenses/GNU-COPYING, licenses/bsd.txt, licenses/cpl1.0.txt, licenses/IBM-LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.10.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=18e587f5f1869f9d87edc4e77e7d5ddcacfd0966d15e5fb45ce520b0fe9ff03e
TERMUX_PKG_DEPENDS="libsqlite, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-java"

termux_step_pre_configure() {
	./bootstrap
}
