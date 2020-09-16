TERMUX_PKG_HOMEPAGE=https://capnproto.org/
TERMUX_PKG_DESCRIPTION="Cap'n Proto tool and library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://capnproto.org/capnproto-c++-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d1f40e47574c65700f0ec98bf66729378efabe3c72bc0cda795037498541c10d
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
    ./configure \
        --prefix=$TERMUX_PREFIX \
        --host=$TERMUX_HOST_PLATFORM
}