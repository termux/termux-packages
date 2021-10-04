TERMUX_PKG_HOMEPAGE=https://github.com/muesli/duf
TERMUX_PKG_DESCRIPTION="Disk usage/free utility"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.6.2
TERMUX_PKG_SRCURL=https://github.com/muesli/duf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f2314d8e5e133a6ce93968b3450c1710a3e432cb4a5dfc528aa0317d968a8988
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
        termux_setup_golang

        cd "$TERMUX_PKG_SRCDIR"

        mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/muesli"
        cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/muesli/duf"
        cd "${TERMUX_PKG_BUILDDIR}/src/github.com/muesli/duf"

        go get -d -v
        go build
}

termux_step_make_install() {
        install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/muesli/duf/duf \
                         $TERMUX_PREFIX/bin/duf
        mkdir -p $TERMUX_PREFIX/share/doc/duf

        install ${TERMUX_PKG_BUILDDIR}/src/github.com/muesli/duf/README.md \
                        $TERMUX_PREFIX/share/doc/duf
}
