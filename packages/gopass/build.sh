TERMUX_PKG_HOMEPAGE=https://github.com/gopasspw/gopass
TERMUX_PKG_DESCRIPTION="The slightly more awesome standard unix password manager for teams"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.6"
TERMUX_PKG_SRCURL=https://github.com/gopasspw/gopass/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=80d0a738ad1a4943e7e98a2db7d11e2b9abb890af8986307e1f0e40cbbf0b00d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="git, gnupg"
TERMUX_PKG_SUGGESTS="termux-api, openssh"

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p ./src
	mkdir -p ./src/github.com/gopasspw
	ln -sf "$TERMUX_PKG_SRCDIR" ./src/github.com/gopasspw/gopass

	rm -f ./src/github.com/gopasspw/gopass/gopass
	make -C ./src/github.com/gopasspw/gopass build CLIPHELPERS="-X github.com/gopasspw/gopass/pkg/clipboard.Helpers=termux-api'"
	install -Dm700 \
		./src/github.com/gopasspw/gopass/gopass \
		"$TERMUX_PREFIX"/bin/gopass
}
