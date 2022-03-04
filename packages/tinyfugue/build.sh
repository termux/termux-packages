TERMUX_PKG_HOMEPAGE=http://tinyfugue.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Flexible, screen-oriented MUD client, for use with any type of MUD"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0b8
TERMUX_PKG_REVISION=2
_COMMIT=854c76f33a4eda6cd64e0b7dc3e07e5de8bbfada
TERMUX_PKG_SRCURL=https://github.com/Longlius/tinyfugue/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=59579de448b7e892a2b4dbfa7a7db7859382a90ec2bd77ce50c515358253461d
TERMUX_PKG_DEPENDS="ncurses, openssl, pcre, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-termcap=ncurses
--disable-mailcheck
"

termux_step_pre_configure() {
	# CFLAGS are passed utilities built for host, but GCC
	# can't understand "-Oz".
	CFLAGS="${CFLAGS/-Oz/-Os}"
}
