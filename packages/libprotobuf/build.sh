TERMUX_PKG_HOMEPAGE=https://github.com/google/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_SRCURL=https://github.com/google/protobuf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2a25c2b71c707c5552ec9afdfb22532a93a339e1ca5d38f163fe4107af08c54c
TERMUX_PKG_FOLDERNAME=protobuf-$TERMUX_PKG_VERSION
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-protoc=$TERMUX_PKG_HOSTBUILD_DIR/src/protoc"
# We extracted libprotobuf from protobuf earlier:
TERMUX_PKG_CONFLICTS="protobuf (<= 3.0.0)"

termux_step_post_extract_package () {
	./autogen.sh
}
