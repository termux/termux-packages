TERMUX_PKG_HOMEPAGE=https://getmonero.org/
TERMUX_PKG_DESCRIPTION="A private, secure, untraceable, decentralised digital currency"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.18.3.4"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=git+https://github.com/monero-project/monero
TERMUX_PKG_DEPENDS="boost, libc++, libprotobuf, libsodium, libunbound, libusb, libzmq, miniupnpc, openssl, readline"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DReadline_ROOT_DIR=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	termux_setup_protobuf

	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
	LDFLAGS+=" -lminiupnpc"
}

termux_step_post_configure() {
	local bin=$TERMUX_PKG_BUILDDIR/_prefix/bin
	mkdir -p $bin
	$CC_FOR_BUILD \
		$TERMUX_PKG_SRCDIR/translations/generate_translations_header.c \
		-o $bin/generate_translations_header_for_build
	export PATH=$bin:$PATH
}
