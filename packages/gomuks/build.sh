TERMUX_PKG_HOMEPAGE=https://go.mau.fi/gomuks
TERMUX_PKG_DESCRIPTION="A terminal Matrix client written in Go"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/gomuks/gomuks/archive/refs/tags/v0.${TERMUX_PKG_VERSION/.}.0.tar.gz"
TERMUX_PKG_SHA256=d01e3b23fe759f62e7619304b6cab8f6676978ed685869f1ce55a7157ac8c409
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="0\.\K\d+(?=\.0)"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/([0-9][0-9])([0-9][0-9])/\1.\2/"
TERMUX_PKG_DEPENDS="libolm, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
# i686 fails to compile:
# go.mau.fi/goheif/dav1d
# In file included from dav1d-tmpl-16.c:2:
# In file included from ./dav1d-tmpl.inl:1:
# In file included from ./src/cdef_apply_tmpl.c:28:
# go/pkg/mod/go.mau.fi/goheif@v0.0.0-20260413100809-7ec7087b8d7d/dav1d/config.h:30:2: error: "Unsupported architecture. Only x86_64, ARM64, and RISC-V are supported."
TERMUX_PKG_EXCLUDED_ARCHES=i686

termux_step_host_build() {
	termux_setup_golang

	GOBIN="$TERMUX_PKG_HOSTBUILD_DIR" GOOS=linux GOARCH=amd64 go install go.mau.fi/util/cmd/maubuild@latest
}

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH="$TERMUX_PKG_SRCDIR/go"
	go get ./cmd/gomuks
	chmod +w "$GOPATH" -R

	local d
	for d in go/pkg/mod/go.mau.fi/goheif*; do
		patch -p1 -d "${d}" < "$TERMUX_PKG_BUILDER_DIR/goheif-no-pthread_getaffinity_np.diff"
	done
}

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	export GOPATH="$TERMUX_PKG_SRCDIR/go"
	# This is adapted directly from the upstream `./build-noweb.sh`
	# https://github.com/gomuks/gomuks/blob/v0.2511.0/build-noweb.sh
	mkdir -p web/dist/
	touch web/dist/empty
	BINARY_NAME=gomuks MAU_VERSION_PACKAGE=go.mau.fi/gomuks/version $TERMUX_PKG_HOSTBUILD_DIR/maubuild "$@"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" gomuks
}
