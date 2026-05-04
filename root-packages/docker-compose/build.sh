TERMUX_PKG_HOMEPAGE=https://github.com/docker/compose
TERMUX_PKG_DESCRIPTION="Compose is a tool for defining and running multi-container Docker applications."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.3"
TERMUX_PKG_SRCURL="https://github.com/docker/compose/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=19c7219c97390473bb96530153e64fce98d4b05ecf6f73016e564201d99512e7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=docker

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd $TERMUX_PKG_SRCDIR
	mkdir bin/
	if ! [ -z "$GOOS" ];then export GOOS=android;fi
	go build -o bin/docker-compose -ldflags="-s -w -X github.com/docker/compose/v2/internal.Version=${TERMUX_PKG_VERSION}" ./cmd
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/libexec/docker/cli-plugins "${TERMUX_PKG_SRCDIR}"/bin/docker-compose
}
