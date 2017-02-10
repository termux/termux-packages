TERMUX_PKG_HOMEPAGE=http://libusb.info/
TERMUX_PKG_DESCRIPTION="A cross-platform user library to access USB devices"
TERMUX_PKG_VERSION=1.0.21
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-${TERMUX_PKG_VERSION}/libusb-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a5b08c05bc5e38c81c2d59c29954d5916646f4ff46f51381b3f624384e4ac01
#TERMUX_PKG_BUILD_IN_SRC=yes
#TERMUX_PKG_FOLDERNAME=libusb
#TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --host=x86_64--pc-linux-gnu --build x86_64--pc-linux-gnu"
#TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_pre_configure(){
    cd ${TERMUX_PKG_SRCDIR}
#    export regcomp_works=yes
    ./autogen.sh
#    chmod +x *
#    LDFLAGS+=" -llog"

}
