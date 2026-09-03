TERMUX_PKG_HOMEPAGE="https://github.com/kubernetes/minikube"
TERMUX_PKG_DESCRIPTION="minikube implements a local Kubernetes cluster."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.39.0"
TERMUX_PKG_SRCURL="https://github.com/kubernetes/minikube/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=052b5b75f5a714a2d619be69bd9826083b42515d810cf1cac591ef0835be7fd9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dockerd, kubectl"
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
