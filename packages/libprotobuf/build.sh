TERMUX_PKG_HOMEPAGE=https://github.com/protocolbuffers/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
# utf8_range is licensed under MIT
TERMUX_PKG_LICENSE="BSD 3-Clause, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE
third_party/utf8_range/LICENSE
"
TERMUX_PKG_MAINTAINER="@termux"
# When bumping version:
# - update SHA256 checksum for $_PROTOBUF_ZIP in
#     $TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_protobuf.sh
# - ALWAYS bump revision of reverse dependencies and rebuild them.
TERMUX_PKG_VERSION="2:33.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=0c98bb704ceb4e68c92f93907951ca3c36130bc73f87264e8c0771a80362ac97
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="abseil-cpp, libc++, zlib"
TERMUX_PKG_BREAKS="libprotobuf-dev, protobuf-dev, protobuf-static, libutf8-range"
TERMUX_PKG_REPLACES="libprotobuf-dev, protobuf-dev, protobuf-static, libutf8-range"
TERMUX_PKG_CONFLICTS="protobuf-static"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprotobuf_ABSL_PROVIDER=package
-Dprotobuf_BUILD_TESTS=OFF
-DBUILD_SHARED_LIBS=ON
-DCMAKE_INSTALL_LIBDIR=lib
"
