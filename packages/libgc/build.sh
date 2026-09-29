TERMUX_PKG_HOMEPAGE=https://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="README.QUICK"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.2.12"
TERMUX_PKG_SRCURL=https://github.com/bdwgc/bdwgc/releases/download/v$TERMUX_PKG_VERSION/gc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=42e5194ad06ab6ffb806c83eb99c03462b495d979cda782f3c72c08af833cd4e
TERMUX_PKG_BREAKS="libgc-dev"
TERMUX_PKG_REPLACES="libgc-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libatomic-ops=none"
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.[1-9]\d*" # all excluding experimental releases (ending with ".0")

termux_step_post_get_source() {
	./autogen.sh
}
