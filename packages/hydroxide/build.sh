TERMUX_PKG_HOMEPAGE=https://github.com/emersion/hydroxide
TERMUX_PKG_DESCRIPTION="A third-party, open-source ProtonMail CardDAV, IMAP and SMTP bridge"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.19
TERMUX_PKG_SRCURL=https://github.com/emersion/hydroxide/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=197538f8432ceb23ee0c2058549fa198e0183b9ac311a638a3d632bc0c5e3ce1

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR
	go build ./cmd/hydroxide
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "${TERMUX_PKG_SRCDIR}"/hydroxide
}
