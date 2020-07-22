TERMUX_PKG_HOMEPAGE=https://github.com/apple/swift-corelibs-libdispatch
TERMUX_PKG_DESCRIPTION="The libdispatch project, for concurrency on multicore hardware"
TERMUX_PKG_LICENSE="Apache-2.0"
_VERSION=5.2.3
TERMUX_PKG_VERSION=1:${_VERSION}
TERMUX_PKG_SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/swift-${_VERSION}-RELEASE.tar.gz
TERMUX_PKG_SHA256=89b5910e80599d3168096f1dc9fb8883d6ecb042cdee144209f03b783249bdda
TERMUX_PKG_DEPENDS="libc++, libblocksruntime"
