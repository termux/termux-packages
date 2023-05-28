TERMUX_PKG_HOMEPAGE=https://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="README.QUICK"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.2.4
TERMUX_PKG_SRCURL=https://github.com/ivmai/bdwgc/releases/download/v$TERMUX_PKG_VERSION/gc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3d0d3cdbe077403d3106bb40f0cbb563413d6efdbb2a7e1cd6886595dec48fc2
TERMUX_PKG_BREAKS="libgc-dev"
TERMUX_PKG_REPLACES="libgc-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libatomic-ops=none"
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"

termux_step_post_get_source() {
	./autogen.sh
}
