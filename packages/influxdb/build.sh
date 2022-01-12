TERMUX_PKG_HOMEPAGE=https://www.influxdata.com/
TERMUX_PKG_DESCRIPTION="An open source time series database with no external dependencies"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# It cannot be simply updated to the 2.0 series, for which the build system is
# pretty much different from that for 1.x.
_GIT_BRANCH=1.8
TERMUX_PKG_VERSION=${_GIT_BRANCH}.10
_COMMIT=688e697c51fd5353725da078555adbeff0363d01
TERMUX_PKG_SRCURL=https://github.com/influxdata/influxdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4f53c61f548bab7cb805af0d02586263d9a348dc18baf90efb142b029e2e7097
TERMUX_PKG_BUILD_IN_SRC=true
_GO_LDFLAGS="
-X main.version=${TERMUX_PKG_VERSION}
-X main.branch=${_GIT_BRANCH}
-X main.commit=${_COMMIT}
"

termux_step_pre_configure() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR/_go
	mkdir -p $GOPATH
	go mod tidy
}

termux_step_make() {
	go install -ldflags="${_GO_LDFLAGS}" ./...
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $GOPATH/bin/*/influx*
}
