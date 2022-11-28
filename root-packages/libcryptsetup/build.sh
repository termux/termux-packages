TERMUX_PKG_HOMEPAGE=https://gitlab.com/cryptsetup/cryptsetup/
TERMUX_PKG_DESCRIPTION="Userspace setup tool for transparent encryption of block devices using dm-crypt"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.edge.kernel.org/pub/linux/utils/cryptsetup/v${TERMUX_PKG_VERSION:0:3}/cryptsetup-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fc0df945188172264ec5bf1d0bda08264fadc8a3f856d47eba91f31fe354b507
TERMUX_PKG_DEPENDS="json-c, libdevmapper, libgcrypt, libuuid, util-linux, openssl, libiconv, argon2"
TERMUX_PKG_BREAKS="cryptsetup-dev, cryptsetup (<< 2.4.3-1)"
TERMUX_PKG_REPLACES="cryptsetup-dev, cryptsetup (<< 2.4.3-1)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-luks2-lock-path=$TERMUX_PREFIX/var/run
--enable-libargon2
--disable-ssh-token
"

termux_step_pre_configure() {
	export LDFLAGS+=" -liconv"

	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
