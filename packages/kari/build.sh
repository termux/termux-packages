TERMUX_PKG_HOMEPAGE=https://github.com/Dhairya3391/kari
TERMUX_PKG_DESCRIPTION="Terminal-based media browser and streamer (anime, movies, TV)"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER="@Dhairya3391"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_SRCURL=https://github.com/Dhairya3391/kari/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=SKIP
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_setup_variables() {
	:
}

termux_step_make() {
	termux_setup_golang
	cd "$TERMUX_PKG_SRCDIR"
	go build \
		-trimpath \
		-buildmode=pie \
		-ldflags="-s -w -X kari/internal/app.Version=$TERMUX_PKG_VERSION -X kari/internal/app.Commit=$(git rev-parse --short HEAD)" \
		-o kari \
		./cmd/kari
}

termux_step_make_install() {
	install -Dm700 kari "$TERMUX_PREFIX/bin/kari"
}
