TERMUX_PKG_HOMEPAGE=https://github.com/jesseduffield/lazygit
TERMUX_PKG_DESCRIPTION="Simple terminal UI for git commands"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_SRCURL=https://github.com/jesseduffield/lazygit/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a1f18864ac737901e2f73e0a3d15e74e96c48b9f370aff9e9f394a34b20b0aa4
TERMUX_PKG_RECOMMENDS=git

termux_step_make() {
        termux_setup_golang

        cd "$TERMUX_PKG_SRCDIR"

        mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield"
        cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit"
        cd "${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit"

        go get -d -v
        go build
}

termux_step_make_install() {
        mkdir -p $TERMUX_PREFIX/share/doc/lazygit

        install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit/lazygit \
                $TERMUX_PREFIX/bin/lazygit

        cp -a ${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit/docs/* \
                $TERMUX_PREFIX/share/doc/lazygit/

}
