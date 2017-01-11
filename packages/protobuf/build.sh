TERMUX_PKG_HOMEPAGE=https://code.google.com/p/protobuf/
TERMUX_PKG_DESCRIPTION="Library for encoding structured data in an efficient yet extensible format"
TERMUX_PKG_VERSION=2.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/google/protobuf/releases/download/v${TERMUX_PKG_VERSION}/protobuf-${TERMUX_PKG_VERSION}.tar.bz2
# Build a host build first and use the host build protoc:
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-protoc=$TERMUX_PKG_HOSTBUILD_DIR/src/protoc"

# Version 3.1.0 currently fails to build:
# TERMUX_PKG_VERSION=3.1.0
# TERMUX_PKG_SRCURL=https://github.com/google/protobuf/releases/download/v${TERMUX_PKG_VERSION}/protobuf-cpp-${TERMUX_PKG_VERSION}.tar.gz
# TERMUX_PKG_FOLDERNAME=protobuf-$TERMUX_PKG_VERSION
