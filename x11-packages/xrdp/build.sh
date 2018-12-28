TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://github.com/neutrinolabs/xrdp
TERMUX_PKG_DESCRIPTION="An open source remote desktop protocol (RDP) server"
TERMUX_PKG_VERSION=0.9.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/neutrinolabs/xrdp/releases/download/v${TERMUX_PKG_VERSION}/xrdp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bbb2c114903d65c212cb2cca0b11bb2620e5034fa9353e0479bc8aa9290b78ee
TERMUX_PKG_DEPENDS="libandroid-shmem, libandroid-support, libcrypt, libice, libsm, libuuid, libx11, libxau, libxcb, libxfixes, libxdmcp, libxrandr, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pam
--enable-static
--with-socketdir=$TERMUX_PREFIX/tmp/.xrdp
"

TERMUX_PKG_CONFFILES="
etc/xrdp/xrdp.ini
etc/xrdp/xrdp_keyboard.ini
etc/xrdp/sesman.ini
etc/xrdp/startwm.sh
etc/xrdp/reconnectwm.sh
etc/xrdp/xrdp.sh
"

termux_step_pre_configure() {
    export LIBS="-landroid-shmem -llog"
}

termux_step_post_make_install() {
    mv -f "${TERMUX_PREFIX}/sbin/xrdp" "${TERMUX_PREFIX}/bin/xrdp"
    mv -f "${TERMUX_PREFIX}/sbin/xrdp-chansrv" "${TERMUX_PREFIX}/bin/xrdp-chansrv"
    mv -f "${TERMUX_PREFIX}/sbin/xrdp-sesman" "${TERMUX_PREFIX}/bin/xrdp-sesman"
    mkdir -p "${TERMUX_PREFIX}/libexec/xrdp"

    for bin in xrdp xrdp-chansrv xrdp-genkeymap xrdp-keygen xrdp-sesadmin xrdp-sesman xrdp-sesrun; do
        mv -f "${TERMUX_PREFIX}/bin/${bin}" "${TERMUX_PREFIX}/libexec/xrdp/${bin}"
        {
            echo "#!${TERMUX_PREFIX}/bin/sh"
            echo "export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${TERMUX_PREFIX}/lib/xrdp"
            echo "exec ${TERMUX_PREFIX}/libexec/xrdp/${bin} \"\${@}\""
        } > "${TERMUX_PREFIX}/bin/${bin}"
        chmod 700 "${TERMUX_PREFIX}/bin/${bin}"
    done
    unset bin
}

termux_step_create_debscripts() {
    {
        echo "#!${TERMUX_PREFIX}/bin/sh"
        echo "if [ ! -e \"${TERMUX_PREFIX}/etc/xrdp/rsakeys.ini\" ]; then"
        echo "    xrdp-keygen xrdp \"${TERMUX_PREFIX}/etc/xrdp/rsakeys.ini\""
        echo "fi"
    } > ./postinst
    chmod 755 postinst
}
