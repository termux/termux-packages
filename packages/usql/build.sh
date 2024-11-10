TERMUX_PKG_HOMEPAGE=https://github.com/xo/usql
TERMUX_PKG_DESCRIPTION="A universal command-line interface for SQL databases"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flipee"
TERMUX_PKG_VERSION="0.19.4"
TERMUX_PKG_SRCURL=https://github.com/xo/usql/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=61aff0f9448ca9d90894bdf99276186f87b5a91ab196ff45133f34c61475b717
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	go mod tidy
	go mod vendor
}

termux_step_make() {
	termux_setup_golang

	# Build and replace resvg
	local _resvg_go_url="$(cat go.mod | grep resvg | awk '{print $1}')"
	local _resvg_go_srcdir="$TERMUX_PKG_SRCDIR"/vendor/$_resvg_go_url/
	(
		local _resvg_version="$(cat "$_resvg_go_srcdir"/version.txt)"
		git clone https://github.com/RazrFalcon/resvg.git -b $_resvg_version --depth=1
		cd resvg/crates/c-api
		termux_setup_rust
		cargo build --release \
			--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
			--target "$CARGO_TARGET_NAME" \
			--locked
		patch -p1 -d "$_resvg_go_srcdir"/ < "$TERMUX_PKG_BUILDER_DIR"/resvg-i686.diff
		mkdir -p "$_resvg_go_srcdir"/libresvg/linux_$GOARCH
		cp ../../crates/c-api/resvg.h \
			"$_resvg_go_srcdir"/libresvg/resvg.h
		cp ../../target/$CARGO_TARGET_NAME/release/libresvg.a \
			"$_resvg_go_srcdir"/libresvg/linux_$GOARCH/libresvg.a
	)

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
