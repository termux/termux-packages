TERMUX_PKG_HOMEPAGE=https://ravencoin.org/
TERMUX_PKG_DESCRIPTION="A peer-to-peer blockchain, handling the efficient creation and transfer of assets from one party to another"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.6.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/RavenProject/Ravencoin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=42e8444e9e21eecfed1a546dffe6f2418271e890038a7d9d9a856b376a6284e8
TERMUX_PKG_DEPENDS="boost, libc++, libevent, libzmq, miniupnpc, openssl"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, libdb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--disable-wallet
--with-boost=$TERMUX_PREFIX/lib
--with-boost-libdir=$TERMUX_PREFIX/lib
"

termux_step_pre_configure() {
	autoreconf -fi

	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
