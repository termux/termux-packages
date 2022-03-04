TERMUX_PKG_HOMEPAGE=https://getmonero.org/
TERMUX_PKG_DESCRIPTION="A private, secure, untraceable, decentralised digital currency"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.17.3.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/monero-project/monero.git
TERMUX_PKG_DEPENDS="boost, libprotobuf, libzmq, openssl, readline, unbound"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"

termux_step_pre_configure() {
	termux_setup_protobuf

	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
}

termux_step_post_configure() {
	local bin=$TERMUX_PKG_BUILDDIR/_prefix/bin
	mkdir -p $bin
	$CC_FOR_BUILD \
		$TERMUX_PKG_SRCDIR/translations/generate_translations_header.c \
		-o $bin/generate_translations_header_for_build
	export PATH=$bin:$PATH
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
