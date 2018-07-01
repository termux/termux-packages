TERMUX_PKG_HOMEPAGE=https://github.com/google/protobuf
TERMUX_PKG_DESCRIPTION="Protocol buffers C++ library"
TERMUX_PKG_VERSION=3.6.0.1
TERMUX_PKG_SHA256=1144ef1fa9c50d3c04880f363b988df6ca6a66e337a945f1661cf4256ffba749
TERMUX_PKG_SRCURL=https://github.com/google/protobuf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-protoc=$TERMUX_PKG_HOSTBUILD_DIR/src/protoc"
# We extracted libprotobuf from protobuf earlier:
TERMUX_PKG_CONFLICTS="protobuf (<= 3.0.0)"

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR/configure" --prefix=$TERMUX_PKG_HOSTBUILD_DIR/install
	# We install protobuf so that libgrpc can use it in a hackish way:
	make -j $TERMUX_MAKE_PROCESSES install
}

termux_step_post_extract_package () {
	./autogen.sh
}
