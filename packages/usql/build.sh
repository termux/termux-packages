TERMUX_PKG_HOMEPAGE=https://github.com/xo/usql
TERMUX_PKG_DESCRIPTION="A universal command-line interface for SQL databases"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flipee"
TERMUX_PKG_VERSION="0.19.24"
TERMUX_PKG_SRCURL=https://github.com/xo/usql/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b4a78bf942754dfb835710533a25a83f52d0cafb3a4caf896a92398886b14b1c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	local tags="most no_adodb no_duckdb"
	if [ "${TERMUX_ARCH}" = "arm" ] || [ "${TERMUX_ARCH}" = "i686" ]; then
		tags="$tags no_netezza no_chai"
	fi

	go build \
		-trimpath \
		-tags="$tags" \
		-ldflags="-X github.com/xo/usql/text.CommandName=usql
		-X github.com/xo/usql/text.CommandVersion=$TERMUX_PKG_VERSION" \
		-o usql
}

termux_step_make_install() {
	install -Dm755 "$TERMUX_PKG_SRCDIR/usql" -t "$TERMUX_PREFIX/bin"

	install -Dm644 "$TERMUX_PKG_SRCDIR/README.md" -t "$TERMUX_PREFIX/share/doc/usql"
}
