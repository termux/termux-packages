TERMUX_PKG_HOMEPAGE=https://github.com/jesseduffield/lazygit
TERMUX_PKG_DESCRIPTION="Simple terminal UI for git commands"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="0.53.0"
TERMUX_PKG_SRCURL=https://github.com/jesseduffield/lazygit/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c160053ae99cb741c6d4295d52f917e492168b204780f9ad1afe8f984c6604a6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RECOMMENDS=git
TERMUX_PKG_SUGGESTS=diff-so-fancy

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield"
	cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit"
	cd "${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit"

	go build \
	-trimpath \
	-mod=readonly \
	-modcacherw \
	-ldflags "\
	-X main.date=$(date --date=@${SOURCE_DATE_EPOCH} -u +%Y-%m-%dT%H:%M:%SZ) \
	-X main.buildSource=termux \
	-X main.version=${TERMUX_PKG_VERSION} \
	-X main.commit=v${TERMUX_PKG_VERSION} \
	"
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/doc/lazygit

	install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit/lazygit \
		$TERMUX_PREFIX/bin/lazygit

	cp -a ${TERMUX_PKG_BUILDDIR}/src/github.com/jesseduffield/lazygit/docs/* \
		$TERMUX_PREFIX/share/doc/lazygit/

}
