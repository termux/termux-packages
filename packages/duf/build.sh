TERMUX_PKG_HOMEPAGE=https://github.com/muesli/duf
TERMUX_PKG_DESCRIPTION="Disk usage/free utility"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_SRCURL=https://github.com/muesli/duf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=238ace11966ab3b1f99e5488a9f161ebc97aba7600a8f09884110d0572309491

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
