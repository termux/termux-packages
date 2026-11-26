TERMUX_PKG_HOMEPAGE=https://github.com/wagoodman/dive
TERMUX_PKG_DESCRIPTION="A tool for exploring a Docker image, layer contents, and discovering ways to shrink its size"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.13.1"
TERMUX_PKG_SRCURL=https://github.com/wagoodman/dive/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2a9666e9c3fddd5e2e5bad81dccda520b8102e7cea34e2888f264b4eb0506852
TERMUX_PKG_DEPENDS="docker-cli"
TERMUX_PKG_RECOMMENDS="dockerd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o dive.bin \
		.
}

termux_step_make_install() {
	install -Dm755 dive.bin "$TERMUX_PREFIX/libexec/dive.real"

	install -Dm755 /dev/stdin "$TERMUX_PREFIX/bin/dive" <<-SHELL_EOF
		#!${TERMUX_PREFIX}/bin/sh
		export DOCKER_HOST="\${DOCKER_HOST:-unix://${TERMUX_PREFIX}/var/run/docker.sock}"
		exec "${TERMUX_PREFIX}/libexec/dive.real" "\$@"
	SHELL_EOF
}

termux_step_create_debscripts() {
	cat >postinst <<-POSTINST_EOF
		#!${TERMUX_PREFIX}/bin/sh
		echo "'dive' requires a preexisting configuration of the real 'docker' package in Termux before it can be used."
	POSTINST_EOF
}
