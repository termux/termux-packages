TERMUX_PKG_HOMEPAGE="https://github.com/kubernetes/minikube"
TERMUX_PKG_DESCRIPTION="minikube implements a local Kubernetes cluster."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.30.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/kubernetes/minikube/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e23fbb1fc3028370968f5bf4777aacbeb7e1fd3d2e96e7ed090860cedbd62219
TERMUX_PKG_DEPENDS="docker, kubectl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	mkdir -p bin
	go build -o bin/minikube ./cmd/minikube
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin bin/minikube
}
