TERMUX_PKG_HOMEPAGE=https://github.com/xo/usql
TERMUX_PKG_DESCRIPTION="A universal command-line interface for SQL databases"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flipee"
TERMUX_PKG_VERSION="0.19.3"
TERMUX_PKG_SRCURL=https://github.com/xo/usql/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3955e13c7108cb4a3ebb968dafa501db72d4f4fa0ddf6fb128cceb84e5a3d4c4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR

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
