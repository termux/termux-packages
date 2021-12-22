TERMUX_PKG_HOMEPAGE=https://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(8.0.6
                    7.6.12)
TERMUX_PKG_SRCURL=(https://github.com/ivmai/bdwgc/releases/download/v$TERMUX_PKG_VERSION/gc-$TERMUX_PKG_VERSION.tar.gz
                   https://github.com/ivmai/libatomic_ops/releases/download/v${TERMUX_PKG_VERSION[1]}/libatomic_ops-${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(3b4914abc9fa76593596773e4da671d7ed4d5390e3d46fbf2e5f155e121bea11
                   f0ab566e25fce08b560e1feab6a3db01db4a38e5bc687804334ef3920c549f3e)
TERMUX_PKG_BREAKS="libgc-dev"
TERMUX_PKG_REPLACES="libgc-dev"
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"


termux_step_post_get_source() {
	mv libatomic_ops-${TERMUX_PKG_VERSION[1]} libatomic_ops
	./autogen.sh
}
