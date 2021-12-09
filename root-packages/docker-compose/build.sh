TERMUX_PKG_HOMEPAGE=https://github.com/docker/compose
TERMUX_PKG_DESCRIPTION="Compose is a tool for defining and running multi-container Docker applications."
TERMUX_PKG_SHA256=001cf72f6bc8a8c43d100389e0bbd3d4d5f5c523f4e3f7ddd53f6a4cd2d6cb18
TERMUX_PKG_VERSION="2.2.2"
TERMUX_PKG_SRCURL="https://github.com/docker/compose/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_DEPENDS=docker

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd $TERMUX_PKG_SRCDIR
	mkdir bin/
	go build -o bin/docker-compose ./cmd
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "${TERMUX_PKG_SRCDIR}"/bin/docker-compose
}
