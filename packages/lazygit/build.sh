TERMUX_PKG_HOMEPAGE=https://github.com/jesseduffield/lazygit
TERMUX_PKG_DESCRIPTION="simple terminal UI for git commands"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.22.8
TERMUX_PKG_SRCURL=https://github.com/jesseduffield/lazygit/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1771c113b8b93db3321a90ff8270e736628a156a44bd6963200656a49ab488c1
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
        mkdir -p $TERMUX_PREFIX/share/doc/lazygit/keybindings

        install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit/lazygit \
                $TERMUX_PREFIX/bin/lazygit

        install ${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit/docs/{Config,Custom_Pagers,Custom_Command_Keybindings,Undoing}.md \
                $TERMUX_PREFIX/share/doc/lazygit

        install ${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit/docs/keybindings{Custom_Keybindings,Keybindings_en,Keybindings_nl, Keybindings_pl} \
                $TERMUX_PREFIX/share/doc/lazygit/keybindings/

}
