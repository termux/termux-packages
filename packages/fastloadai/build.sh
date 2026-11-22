TERMUX_PKG_HOMEPAGE=https://github.com/ciao22king/FastLoadAI
TERMUX_PKG_DESCRIPTION="Hardware-aware local GGUF model runner and chat UI"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@ciao22king"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL=https://github.com/ciao22king/FastLoadAI/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dbc44e8561e7d3da483027efc3558a386fbd740866f3d73b5af84d6bb59d11c5
TERMUX_PKG_DEPENDS="llama-cpp"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"
	go build -trimpath -buildvcs=false \
		-ldflags "-s -w -X github.com/ciao22king/FastLoadAI/internal/tui.Version=${TERMUX_PKG_VERSION}" \
		-o fastloadai ./cmd/fastloadai
}

termux_step_make_install() {
	install -Dm755 fastloadai "$TERMUX_PREFIX/bin/fastloadai"
	install -Dm644 LICENSE "$TERMUX_PREFIX/share/licenses/fastloadai/LICENSE"
	install -Dm644 README.md "$TERMUX_PREFIX/share/doc/fastloadai/README.md"
}
