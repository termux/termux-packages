TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://github.com/neutrinolabs/xrdp
TERMUX_PKG_DESCRIPTION="An open source remote desktop protocol (RDP) server"
TERMUX_PKG_VERSION=0.9.8
TERMUX_PKG_SRCURL=https://github.com/neutrinolabs/xrdp/releases/download/v${TERMUX_PKG_VERSION}/xrdp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bbb2c114903d65c212cb2cca0b11bb2620e5034fa9353e0479bc8aa9290b78ee
TERMUX_PKG_DEPENDS="tigervnc, libcrypt, libxrandr, libopus"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pam
--enable-static
"

termux_step_pre_configure() {
    export LIBS="-landroid-shmem -llog"
}
