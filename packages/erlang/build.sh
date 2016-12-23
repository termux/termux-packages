TERMUX_PKG_HOMEPAGE="http://www.erlang.org/"
TERMUX_PKG_DESCRIPTION="General-purpose concurrent functional programming language developed by Ericsson"
TERMUX_PKG_VERSION="18.3.3"
TERMUX_PKG_DEPENDS="openssl, ncurses"

TERMUX_PKG_SRCURL="https://github.com/erlang/otp/archive/OTP-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_FOLDERNAME="otp-OTP-${TERMUX_PKG_VERSION}"

TERMUX_PKG_HOSTBUILD="yes"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-javac --with-ssl=${TERMUX_TOPDIR}/openssl/src --with-termcap"

termux_step_post_extract_package () {
    rm -Rf "$TERMUX_PKG_HOSTBUILD_DIR"
    export ERL_TOP="$TERMUX_PKG_SRCDIR"
    cd "$ERL_TOP"
    ./otp_build autoconf
}

termux_step_host_build () {
    cd $ERL_TOP
    ./configure --enable-bootstrap-only
    make -j "$TERMUX_MAKE_PROCESSES"
}

termux_step_pre_configure () {
    LDFLAGS+=" -llog -L${TERMUX_TOPDIR}/openssl/src"
}

termux_step_make () {
    cp "${TERMUX_PKG_SRCDIR}/bin/x86_64-unknown-linux-gnu/"* "${TERMUX_PKG_SRCDIR}/bootstrap/bin"
    PATH+=":${TERMUX_PKG_SRCDIR}/bootstrap/bin"
    make -j $TERMUX_MAKE_PROCESSES noboot
}
