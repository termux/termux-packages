TERMUX_PKG_HOMEPAGE=https://github.com/lolbaj/termux-netstore
TERMUX_PKG_DESCRIPTION="Network storage mounting manager for Termux devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="lolbaj <lolbaj94@gmail.com>"
TERMUX_PKG_VERSION=1.7.1
TERMUX_PKG_SRCURL=https://github.com/lolbaj/termux-netstore/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5
TERMUX_PKG_DEPENDS="openssh, nmap, rsync"
TERMUX_PKG_RECOMMENDS="rclone"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm700 bin/termux-netstore "${TERMUX_PREFIX}/bin/termux-netstore"
    install -Dm600 share/man/man1/termux-netstore.1 "${TERMUX_PREFIX}/share/man/man1/termux-netstore.1"
    install -Dm644 README.md "${TERMUX_PREFIX}/share/doc/termux-netstore/README.md"
    install -Dm644 share/bash-completion/completions/termux-netstore "${TERMUX_PREFIX}/share/bash-completion/completions/termux-netstore"

    # Install library files
    mkdir -p "${TERMUX_PREFIX}/lib/termux-netstore"
    cp lib/*.sh "${TERMUX_PREFIX}/lib/termux-netstore/"
    chmod 600 "${TERMUX_PREFIX}/lib/termux-netstore"/*.sh
}
