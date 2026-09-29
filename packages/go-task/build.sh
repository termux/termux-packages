TERMUX_PKG_HOMEPAGE=https://github.com/go-task/task
TERMUX_PKG_DESCRIPTION="A task runner / simpler Make alternative written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.54.0"
TERMUX_PKG_SRCURL="https://github.com/go-task/task/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d9e92770c2c18f135701431d04bb24fb77b5f13464699683892bdfc0b26f2eb8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o task \
		./cmd/task
}

termux_step_make_install() {
	install -Dm755 task "$TERMUX_PREFIX/bin/go-task"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	# the binary is installed as "go-task" (not "task"), TASK_EXE tells it
	# what name to bake into the generated completion scripts
	export TASK_EXE=go-task
	go run ./cmd/task --completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/go-task"
	go run ./cmd/task --completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_go-task"
	go run ./cmd/task --completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/go-task.fish"
}
