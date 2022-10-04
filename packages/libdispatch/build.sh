TERMUX_PKG_HOMEPAGE=https://github.com/apple/swift-corelibs-libdispatch
TERMUX_PKG_DESCRIPTION="The libdispatch project, for concurrency on multicore hardware"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION="1:5.7"
TERMUX_PKG_SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/swift-${TERMUX_PKG_VERSION:2}-RELEASE.tar.gz
TERMUX_PKG_SHA256=b8398571561f3e94053309c55029726af541180e3323ea68e3ca544bbdc57a10
TERMUX_PKG_DEPENDS="libc++, libblocksruntime"
