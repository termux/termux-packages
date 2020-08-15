TERMUX_PKG_HOMEPAGE=https://www.teleconsole.com
TERMUX_PKG_DESCRIPTION="Teleconsole is a free service to share your terminal session with people you trust."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_SRCURL=https://github.com/gravitational/teleconsole/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ba0a231c5501995e2b948c387360eb84e3a44fe2af6540b6439fc58637b0efa4
#TERMUX_PKG_DEPENDS="openssh"

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/gravitational"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/gravitational/teleconsole"
	cd "${GOPATH}/src/github.com/gravitational/teleconsole"
	go get -d -v
	make
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/gravitational/teleconsole/out/teleconsole
}
