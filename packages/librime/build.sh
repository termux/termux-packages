TERMUX_PKG_HOMEPAGE=https://rime.im/
TERMUX_PKG_DESCRIPTION="A modular, extensible input method engine in cross-platform C++ code"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.4
TERMUX_PKG_SRCURL=https://github.com/rime/librime/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aab46984b585aa1b6887e63138663e5b2517179f9d91eaed6ef4d8bb093e3dae
TERMUX_PKG_DEPENDS="boost, google-glog, leveldb, libc++, libopencc, libyaml-cpp, marisa"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, gflags, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TEST=OFF
"
