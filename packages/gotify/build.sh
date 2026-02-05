TERMUX_PKG_HOMEPAGE=https://github.com/gotify/server
TERMUX_PKG_DESCRIPTION="A simple server for sending and receiving messages in real-time per WebSocket."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="2.8.0"
TERMUX_PKG_SRCURL="https://github.com/gotify/server/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0bb4c453c611f889a202687b43d617fd35052c337f1911e4581c076716b4dc7a
TERMUX_PKG_BUILD_DEPENDS="yarn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	termux_setup_nodejs

	export YARN_ENABLE_HARDENED_MODE=0

	local bin="$TERMUX_PKG_BUILDDIR/_bin"
	mkdir -p "$bin"

	local yarn="$bin/yarn"
	cat > "$yarn" <<-EOF
		#!$(command -v sh)
		exec sh $TERMUX_PREFIX/bin/yarn "\$@"
		EOF

	chmod 0755 "$yarn"

	export PATH="$bin:$PATH"

	npm install --global typescript

	(cd ui && yarn install && yarn build)

	export LD_FLAGS="-w -s -X main.Version=${TERMUX_PKG_VERSION} -X main.BuildDate=$(date "+%F-%T") -X main.Commit=${TERMUX_PKG_SHA256} -X main.Mode=prod";

	go build -ldflags="$LD_FLAGS" -o "${TERMUX_PKG_NAME}"
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/bin"
}
