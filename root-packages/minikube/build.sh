TERMUX_PKG_HOMEPAGE="https://github.com/kubernetes/minikube"
TERMUX_PKG_DESCRIPTION="minikube implements a local Kubernetes cluster."
TERMUX_PKG_VERSION=1.28.0
TERMUX_PKG_SRCURL="https://github.com/kubernetes/minikube/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0e64c007b7423999da506aa4fb4002b1ef5847cefafd29d800cc56dbd2b38cc4
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="docker, kubectl"

termux_step_make() {
	set -x
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd $TERMUX_PKG_SRCDIR 
	mkdir bin/
	GIT_SHA=$(wget -qO- "https://api.github.com/repos/kubernetes/minikube/git/ref/tags/v${TERMUX_PKG_VERSION}" | grep "sha"|cut -d '"' -f 4);
	ISO_VERSION=$(wget -qO- "https://github.com/kubernetes/minikube/raw/v${TERMUX_PKG_VERSION}/Makefile" | grep "ISO_VERSION" | grep "=" | cut -d '=' -f 2 | head -n 1);
	storageProvisionerVersion=$(wget -qO- "https://github.com/kubernetes/minikube/raw/v${TERMUX_PKG_VERSION}/Makefile" | grep "STORAGE_PROVISIONER_TAG" | grep "=" | cut -d '=' -f 2 | head -n 1);
	export GOOS=android;
	go build -o bin/minikube k8s.io/minikube/cmd/minikube
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "${TERMUX_PKG_SRCDIR}"/bin/minikube
}
