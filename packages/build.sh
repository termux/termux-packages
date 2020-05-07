TERMUX_PKG_HOMEPAGE=https://github.com/rakshasa/rtorrent/wiki
TERMUX_PKG_DESCRIPTION="Libtorrent BitTorrent library"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.13.8
TERMUX_PKG_SRCURL=https://github.com/rakshasa/libtorrent/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0f6c2e7ffd3a1723ab47fdac785ec40f85c0a5b5a42c1d002272205b988be722
TERMUX_PKG_DEPENDS="openssl"
termux_step_pre_configure() {
        ./autogen.sh
        cd $TERMUX_PKG_BUILDDIR

    
        if [ $TERMUX_ARCH = "arm" ]; then
                _ARCH="armeabi-v7a"
               
        elif [ $TERMUX_ARCH = "i686" ]; then
                _ARCH="x86"
               
        elif [ $TERMUX_ARCH = "x86_64" ]; then
                _ARCH="x86_64"
        elif [ $TERMUX_ARCH = "aarch64" ]; then
                _ARCH=$TERMUX_ARCH
               
        else
                termux_error_exit "Unsupported arch: $TERMUX_ARCH"
        fi

        $TERMUX_PKG_SRCDIR/configure --prefix=$TERMUX_PREFIX --host=$(_ARCH)

}
