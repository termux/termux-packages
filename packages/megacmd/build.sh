TERMUX_PKG_HOMEPAGE=https://mega.nz/cmd
TERMUX_PKG_DESCRIPTION="MEGAcmd provides non UI access to MEGA services."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(1.4.0
                    3.8.2c)
TERMUX_PKG_SRCURL=(https://github.com/meganz/MEGAcmd/archive/${TERMUX_PKG_VERSION[0]}_Linux.tar.gz
                   https://github.com/meganz/sdk/archive/v${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(2a3626a9f1d22303fe2123f984a8ecf3779d6d59ac6c67c1bf43c2423dcb832d
                   50d3c7ec8bf0b8dddadda3715530fb2e4a6d867c93faa2c6cffdbb6ea868eea3)
TERMUX_PKG_DEPENDS="googletest, libc++, libtool, freeimage, c-ares, readline, cryptopp, curl, openssl, libcrypt, libsodium, libsqlite, libuv, libraw, libzen, pcre, wget, zlib, ncurses, mediainfo"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-posix-threads --disable-gcc-hardening --disable-shared --enable-static --disable-silent-rules --with-sodium=$TERMUX_PKG_SRCDIR/deps/ --with-readline=$TERMUX_PKG_SRCDIR/deps/ --with-libuv=$TERMUX_PREFIX --with-cryptopp=$TERMUX_PKG_SRCDIR/deps/ --with-pcre=$TERMUX_PKG_SRCDIR/deps/ --with-sqlite=$TERMUX_PREFIX --with-freeimage=$TERMUX_PREFIX --with-curl=$TERMUX_PREFIX --with-termcap=$TERMUX_PKG_SRCDIR/deps/ --with-libmediainfo=$TERMUX_PKG_SRCDIR/deps/ --with-libzen=$TERMUX_PREFIX --disable-examples --disable-curl-checks"
termux_step_pre_configure() {
	rm -rf sdk
	mv "sdk-${TERMUX_PKG_VERSION[1]}" sdk
	sh autogen.sh
}
termux_step_post_configure() {
	mkdir deps || :
	bash -x ./sdk/contrib/build_sdk.sh -o archives \
	  -e -g -b -l -c -s -u -v -a -q -I -p deps/
}
