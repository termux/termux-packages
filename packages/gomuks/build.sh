TERMUX_PKG_HOMEPAGE=https://go.mau.fi/gomuks
TERMUX_PKG_DESCRIPTION="A terminal Matrix client written in Go"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.01"
TERMUX_PKG_SRCURL="https://github.com/gomuks/gomuks/archive/refs/tags/v0.${TERMUX_PKG_VERSION/.}.0.tar.gz"
TERMUX_PKG_SHA256=954370d1eec42cecbfd05c9e9736e9d4be2cad4201d1c74246ce3500b1d55a67
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="0\.\K\d+(?=\.0)"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/([0-9][0-9])([0-9][0-9])/\1.\2/"
TERMUX_PKG_DEPENDS="libolm, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
# i686 fails to compile:
# go.mau.fi/goheif/libde265
# In file included from libde265.cc:2:
# ./libde265-all.inl:10:10: fatal error: 'alloc_pool.cc' file not found
TERMUX_PKG_EXCLUDED_ARCHES="i686"

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
	local ldflags tag_commit
	# This is adapted directly from the upstream `./build-noweb.sh`
	# https://github.com/gomuks/gomuks/blob/v0.2511.0/build-noweb.sh
	mkdir -p web/dist/
	touch web/dist/empty
	MAUTRIX_VERSION=$(cat go.mod | grep 'maunium.net/go/mautrix ' | head -n1 | awk '{ print $2 }')
	export MAUTRIX_VERSION
	read -r tag_commit _ < <(git ls-remote https://github.com/gomuks/gomuks "refs/tags/v0.${TERMUX_PKG_VERSION/.}.0")
	ldflags+=" -X go.mau.fi/gomuks/version.Tag=${TERMUX_PKG_VERSION}"
	ldflags+=" -X go.mau.fi/gomuks/version.Commit=${tag_commit}"
	ldflags+=" -X 'go.mau.fi/gomuks/version.BuildTime=$(date --utc -Iseconds)'"
	ldflags+=" -X 'maunium.net/go/mautrix.GoModVersion=$MAUTRIX_VERSION'"

	go build -ldflags "$ldflags" ./cmd/gomuks "$@"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" gomuks
}
