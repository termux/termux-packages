TERMUX_PKG_HOMEPAGE=http://x265.org/
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream encoder library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5
TERMUX_PKG_SRCURL=https://bitbucket.org/multicoreware/x265_git/downloads/x265_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e70a3335cacacbba0b3a20ec6fecd6783932288ebc8163ad74bcc9606477cae8
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libx265-dev"
TERMUX_PKG_REPLACES="libx265-dev"

termux_step_pre_configure() {
        if [ $TERMUX_ARCH = "i686" ]; then
                # Avoid text relocations.
                TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ASSEMBLY=OFF"
        elif [ $TERMUX_ARCH = "aarch64" ] || [ $TERMUX_ARCH = "arm" ] \
             && [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
                TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCROSS_COMPILE_ARM=ON"
        fi

        TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/source"

        sed -i "s/@CCTERMUX_HOST_PLATFORM@/${CCTERMUX_HOST_PLATFORM}/" \
            ${TERMUX_PKG_SRCDIR}/CMakeLists.txt
}

