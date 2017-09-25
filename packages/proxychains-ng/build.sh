TERMUX_PKG_HOMEPAGE=https://github.com/rofl0r/proxychains-ng
TERMUX_PKG_DESCRIPTION="a preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies. It is a kind of proxifier."
TERMUX_PKG_VERSION=4.12
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/rofl0r/proxychains-ng/releases/download/v${TERMUX_PKG_VERSION}/proxychains-ng-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=482a549935060417b629f32ddadd14f9c04df8249d9588f7f78a3303e3d03a4e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --prefix=${TERMUX_PREFIX}"
TERMUX_PKG_BUILD_IN_SRC=yes
termux_step_post_make_install(){
    # Remove conf file from previous build, otherwise nothing will be done and it won't be included in the package
    rm -f $TERMUX_PREFIX/etc/proxychains.conf
    make install-config
}


