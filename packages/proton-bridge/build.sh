TERMUX_PKG_HOMEPAGE=https://github.com/ProtonMail/proton-bridge
TERMUX_PKG_DESCRIPTION="ProtonMail Bridge application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.8.10
TERMUX_PKG_SRCURL=https://github.com/ProtonMail/proton-bridge.git
TERMUX_PKG_GIT_BRANCH=br-$TERMUX_PKG_VERSION
TERMUX_PKG_MAINTAINER="Radomír Polách <rp@t4d.cz>"
TERMUX_PKG_DEPENDS=libsecret

# On 32bit arches we get:
# ../build/pkg/mod/github.com/!proton!mail/go-rfc5322@v0.8.0/parser/rfc5322_parser.go:2756: constant 4230534781 overflows int
# ../build/pkg/mod/github.com/!proton!mail/go-rfc5322@v0.8.0/parser/rfc5322_parser.go:2780: constant 4230534781 overflows int
# ../build/pkg/mod/github.com/!proton!mail/go-rfc5322@v0.8.0/parser/rfc5322_parser.go:6683: constant 2740715144 overflows int
# ../build/pkg/mod/github.com/!proton!mail/go-rfc5322@v0.8.0/parser/rfc5322_parser.go:6683: constant 4294967167 overflows int
# ../build/pkg/mod/github.com/!proton!mail/go-rfc5322@v0.8.0/parser/rfc5322_parser.go:11728: constant 4244674173 overflows int
# ../build/pkg/mod/github.com/!proton!mail/go-rfc5322@v0.8.0/parser/rfc5322_parser.go:12153: constant 4292870143 overflows int
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd $TERMUX_PKG_SRCDIR

	make build-nogui
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/proton-bridge \
		"$TERMUX_PREFIX"/bin/proton-bridge
}
