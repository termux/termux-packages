TERMUX_PKG_HOMEPAGE=https://github.com/docker/compose
TERMUX_PKG_DESCRIPTION="Compose is a tool for defining and running multi-container Docker applications."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.27.2"
TERMUX_PKG_SRCURL="https://github.com/docker/compose/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1769596433f68fa68ed67974e796ddb71a96064f18e0d79f5c4259ed5c1be98b
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
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "${TERMUX_PKG_SRCDIR}"/bin/docker-compose
}
