TERMUX_PKG_HOMEPAGE=https://github.com/diocles/apt-transport-tor
TERMUX_PKG_DESCRIPTION="Easily install *.deb packages via Tor"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=0.1.1
TERMUX_PKG_SRCURL=https://github.com/diocles/apt-transport-tor/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04fb5467d3335bbb84747b568337ee06e45cb50e5a5058fec3ee4e7d8f9bea37
TERMUX_PKG_DEPENDS="apt, tor"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    ## we need apt-pkg headers
    if [ -d "${TERMUX_TOPDIR}/apt/build" ]; then
        export CPPFLAGS="${CPPFLAGS} -I${TERMUX_TOPDIR}/apt/build/include"
    else
        echo
        echo "Can't access build directory of APT."
        echo
        exit 1
    fi

    autoreconf -i
}

termux_step_post_make_install() {
    ln -sfr "${TERMUX_PREFIX}/lib/apt/methods/tor" "${TERMUX_PREFIX}/lib/apt/methods/tor+http"
    ln -sfr "${TERMUX_PREFIX}/lib/apt/methods/tor" "${TERMUX_PREFIX}/lib/apt/methods/tor+https"
}
