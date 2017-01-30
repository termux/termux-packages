TERMUX_PKG_HOMEPAGE=https://github.com/google/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_SRCURL=https://github.com/google/protobuf/releases/download/v${TERMUX_PKG_VERSION}/protobuf-cpp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=51d773e4297238b282eaa4c1dd317099675b12eef2b414732b851c00459225c6
TERMUX_PKG_FOLDERNAME=protobuf-$TERMUX_PKG_VERSION
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-protoc=$TERMUX_PKG_HOSTBUILD_DIR/src/protoc"
# We extracted libprotobuf from protobuf earlier::w
TERMUX_PKG_CONFLICTS="protobuf (<= 3.0.0)"
