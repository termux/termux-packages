TERMUX_PKG_HOMEPAGE=https://github.com/golang-migrate/migrate
TERMUX_PKG_DESCRIPTION="Database migrations. CLI and Golang library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="4.19.1"
TERMUX_PKG_SRCURL=https://github.com/golang-migrate/migrate/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=677bf03c19d684dc5bef47e981ec1b4564482cbf5f9b190cb48e110183fd6d25
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-tags 'postgres mysql sqlite3 sqlite cassandra spanner cockroachdb clickhouse' \
		-ldflags="-s -w -X main.Version=${TERMUX_PKG_VERSION}" \
		-o migrate \
		./cmd/migrate
}

termux_step_make_install() {
	install -Dm755 migrate "$TERMUX_PREFIX/bin/migrate"
}
