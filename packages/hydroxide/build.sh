TERMUX_PKG_HOMEPAGE=https://github.com/emersion/hydroxide
TERMUX_PKG_DESCRIPTION="A third-party, open-source ProtonMail CardDAV, IMAP and SMTP bridge"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.24"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/emersion/hydroxide/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bef92acac29a06c4450cf4bcd29fb40f31f20a062520f85964c0939d00df5f98
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR
	go build ./cmd/hydroxide
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "${TERMUX_PKG_SRCDIR}"/hydroxide
}
