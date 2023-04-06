TERMUX_PKG_HOMEPAGE=https://github.com/apple/swift-corelibs-libdispatch
TERMUX_PKG_DESCRIPTION="The libdispatch project, for concurrency on multicore hardware"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION="1:5.8"
TERMUX_PKG_SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/swift-${TERMUX_PKG_VERSION:2}-RELEASE.tar.gz
TERMUX_PKG_SHA256=391d2bcaea22c4aa980400c3a29b3d9991641aa62253b693c0b79c302eafd5a0
TERMUX_PKG_DEPENDS="libc++, libblocksruntime"
