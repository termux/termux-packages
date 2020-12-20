TERMUX_PKG_HOMEPAGE=https://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(8.0.4
                    7.6.10)
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=(https://github.com/ivmai/bdwgc/releases/download/v$TERMUX_PKG_VERSION/gc-$TERMUX_PKG_VERSION.tar.gz
                   https://github.com/ivmai/libatomic_ops/releases/download/v${TERMUX_PKG_VERSION[1]}/libatomic_ops-${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(436a0ddc67b1ac0b0405b61a9675bca9e075c8156f4debd1d06f3a56c7cd289d
                   587edf60817f56daf1e1ab38a4b3c729b8e846ff67b4f62a6157183708f099af)
TERMUX_PKG_BREAKS="libgc-dev"
TERMUX_PKG_REPLACES="libgc-dev"
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"

termux_step_post_get_source() {
	mv libatomic_ops-${TERMUX_PKG_VERSION[1]} libatomic_ops
	./autogen.sh
}
