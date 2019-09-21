TERMUX_PKG_HOMEPAGE=https://github.com/apple/swift-corelibs-libdspatch
TERMUX_PKG_DESCRIPTION="The libdispatch project, for concurrency on multicore hardware"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=5.1
TERMUX_PKG_SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/swift-${TERMUX_PKG_VERSION}-RELEASE.tar.gz
TERMUX_PKG_SHA256=da24d299eecc10e7d4b40a24e0700ca2f73da622795ecf6f4a5da4d33c486662
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_TESTING=OFF"
