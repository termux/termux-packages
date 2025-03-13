TERMUX_PKG_HOMEPAGE=https://stashapp.cc
TERMUX_PKG_DESCRIPTION="Locally hosted web-based app written in Go which organizes and serves your Adult Video"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.27.2"
TERMUX_PKG_SRCURL=https://github.com/stashapp/stash/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=23402a61329d3c57f0d161e469b07a14a7672f799ff9d97bf082c1b67ace2dea
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_nodejs

	pkg install yarn
	cp -r $TERMUX_PKG_SRCDIR/ui/v2.5 ./ui-v2.5
	cd ui-v2.5
	yarn install --frozen-lockfile
	yarn build
}

termux_step_pre_configure() {
	cp -r $TERMUX_PKG_HOSTBUILD_DIR/ui-v2.5/build $TERMUX_PKG_SRCDIR/web/
	termux_setup_golang
}

termux_step_make() {
	export CGO_ENABLED=1
	go build -o stash -trimpath -ldflags="-s -w -extldflags=-static-pie \
	-X 'github.com/stashapp/stash/internal/build.buildstamp=$(date +%Y-%m-%d)' \
	-X 'github.com/stashapp/stash/internal/build.githash=$(git rev-parse --short HEAD 2>/dev/null || echo unknown)' \
	-X 'github.com/stashapp/stash/internal/build.version=${TERMUX_PKG_VERSION}' \
	-X 'github.com/stashapp/stash/internal/build.officialBuild=false'" \
	./cmd/stash
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/stash
}
