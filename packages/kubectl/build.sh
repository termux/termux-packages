TERMUX_PKG_HOMEPAGE=https://kubernetes.io/
TERMUX_PKG_DESCRIPTION="Kubernetes.io client binary"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.30.1"
TERMUX_PKG_SRCURL=https://dl.k8s.io/v$TERMUX_PKG_VERSION/kubernetes-src.tar.gz
TERMUX_PKG_SHA256=e06188c08ff6bd651cdb8d6baa37ceb7906eaf1e165bbe5d74d8e0cd1d19136e
TERMUX_PKG_AUTO_UPDATE=true

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_CACHEDIR"
	mkdir -p "$TERMUX_PKG_SRCDIR"

	termux_download "$TERMUX_PKG_SRCURL" "$TERMUX_PKG_CACHEDIR"/kubernetes-src.tar.gz \
		"$TERMUX_PKG_SHA256"

	tar xf "$TERMUX_PKG_CACHEDIR"/kubernetes-src.tar.gz \
		-C "$TERMUX_PKG_SRCDIR"
}

termux_step_make() {
	termux_setup_golang

	# Needed to generate manpages.
	#(
	#	export GOPATH="$TERMUX_PKG_BUILDDIR/host"
	#	unset GOOS GOARCH CGO_LDFLAGS
	#	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	#	cd "$TERMUX_PKG_SRCDIR"
	#	./hack/update-generated-docs.sh
	#)

	export GOPATH="$TERMUX_PKG_BUILDDIR/target"
	#chmod +w "$TERMUX_PKG_SRCDIR"/_output
	#rm -rf "$TERMUX_PKG_SRCDIR"/_output

	cd "$TERMUX_PKG_SRCDIR"/cmd/kubectl
	go build .
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_SRCDIR"/cmd/kubectl/kubectl \
		"$TERMUX_PREFIX"/bin/kubectl

	#mkdir -p "$TERMUX_PREFIX"/share/man/man1
	#cp -f "$TERMUX_PKG_SRCDIR"/docs/man/man1/kubectl-*.1 \
	#	"$TERMUX_PREFIX"/share/man/man1/
}
