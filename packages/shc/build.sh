TERMUX_PKG_HOMEPAGE="https://neurobin.org/projects/softwares/unix/shc/"
TERMUX_PKG_DESCRIPTION="Shell script compiler"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=4.0.3
TERMUX_PKG_SRCURL=https://github.com/neurobin/shc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7d7fa6a9f5f53d607ab851d739ae3d3b99ca86e2cb1425a6cab9299f673aee16
TERMUX_PKG_DEPENDS="clang"

termux_step_make_install() {
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

  
        $TERMUX_PKG_SRCDIR/configure --prefix=$TERMUX_PREFIX --host=${_ARCH}
        make
        make install
}
