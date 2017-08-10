TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/xorriso
TERMUX_PKG_DESCRIPTION="Tool for creating ISO files."
TERMUX_PKG_VERSION=1.4.7
TERMUX_PKG_SRCURL=https://www.gnu.org/software/xorriso/xorriso-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b54997b71b979768b19ddc38ff15d773ce44cf449e63fb453e20be9d687d396a
TERMUX_PKG_DEPENDS="iconv, libandroid-support, readline, libbz2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-jtethreads"

termux_step_pre_configure() {
        LDFLAGS+=" -landroid-support"
}
