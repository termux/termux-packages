TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/xorriso
TERMUX_PKG_DESCRIPTION="Tool for creating ISO files."
TERMUX_PKG_VERSION=1.4.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.gnu.org/software/xorriso/xorriso-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8c684ae685a5d3151db0f80e60ec4e96aca99c412d5ec6f65965a06ee30cf5e0
TERMUX_PKG_DEPENDS="iconv, libandroid-support, readline, libbz2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-jtethreads"

termux_step_pre_configure() {
        LDFLAGS+=" -landroid-support"
}
