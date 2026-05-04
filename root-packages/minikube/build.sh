TERMUX_PKG_HOMEPAGE="https://github.com/kubernetes/minikube"
TERMUX_PKG_DESCRIPTION="minikube implements a local Kubernetes cluster."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.38.1"
TERMUX_PKG_SRCURL="https://github.com/kubernetes/minikube/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f3401ff708235441d12ee47f5e8b5e7f55e7944585ae2a9bdb4b8cb629838f7c
TERMUX_PKG_AUTO_UPDATE=true
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
