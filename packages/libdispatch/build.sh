TERMUX_PKG_HOMEPAGE=https://github.com/apple/swift-corelibs-libdspatch
TERMUX_PKG_DESCRIPTION="The libdispatch project, for concurrency on multicore hardware"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=2019-09-04
TERMUX_PKG_SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/swift-DEVELOPMENT-SNAPSHOT-${TERMUX_PKG_VERSION}-a.tar.gz
TERMUX_PKG_SHA256=fada9fc9f4c6fac1c8b11d4187deb67329744f412df656d1b77122765db06147
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_TESTING=OFF"
