TERMUX_PKG_HOMEPAGE=https://github.com/emersion/hydroxide
TERMUX_PKG_DESCRIPTION="A third-party, open-source ProtonMail CardDAV, IMAP and SMTP bridge"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.23"
TERMUX_PKG_SRCURL=https://github.com/emersion/hydroxide/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0a47f0ec93ebb7ec04e133f7e89a955f9dc6ef2ff86a89a22fc752fa17e4e644
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
