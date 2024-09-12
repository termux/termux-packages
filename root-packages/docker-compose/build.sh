TERMUX_PKG_HOMEPAGE=https://github.com/docker/compose
TERMUX_PKG_DESCRIPTION="Compose is a tool for defining and running multi-container Docker applications."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.29.3"
TERMUX_PKG_SRCURL="https://github.com/docker/compose/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=55ddbcb65bccfc4f4ac4a45930eab2d1ee8f45ceea3988b68cd25982d688c9df
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
