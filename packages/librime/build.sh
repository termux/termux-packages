TERMUX_PKG_HOMEPAGE=https://rime.im/
TERMUX_PKG_DESCRIPTION="A modular, extensible input method engine in cross-platform C++ code"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.5
TERMUX_PKG_SRCURL=https://github.com/rime/librime/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=046f3cadae862f94b542864df77531cdbe0f9f6f08cdecc58fd02d20be609a71
TERMUX_PKG_DEPENDS="boost, google-glog, leveldb, libc++, libopencc, libyaml-cpp, marisa"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, gflags, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TEST=OFF
"
