TERMUX_PKG_HOMEPAGE=https://github.com/sentinel-cli/sentinel
TERMUX_PKG_DESCRIPTION="Statically compiled, zero-dependency Git pre-commit secret detector"
TERMUX_PKG_LICENSE="AGPL-3.0"
TERMUX_PKG_MAINTAINER="@KhaledHani"
TERMUX_PKG_VERSION="2.0.4"
TERMUX_PKG_SRCURL=https://github.com/sentinel-cli/sentinel/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
# sentinel:ignore
TERMUX_PKG_SHA256=c824aa65e5dfad88e6898cb9faa630a2d3cd970c49126a6b62af6e70ce87ed30
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	# Build with standard Go release optimizations and inject version metadata
	go build -trimpath \
		-ldflags "-s -w -X github.com/sentinel-cli/sentinel/v2/pkg/version.Version=${TERMUX_PKG_VERSION}" \
		-o sentinel ./cmd/sentinel
}

termux_step_make_install() {
	# Install the binary to the Termux system bin prefix
	install -Dm700 "$TERMUX_PKG_SRCDIR/sentinel" "$TERMUX_PREFIX"/bin/sentinel
}
