TERMUX_PKG_HOMEPAGE=https://smallstep.com/cli
TERMUX_PKG_DESCRIPTION="An easy-to-use CLI tool for building, operating, and automating Public Key Infrastructure (PKI) systems and workflows"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.27.0"
TERMUX_PKG_SRCURL=https://github.com/smallstep/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d86ae886b6950bf26b0991e6e317db42e578a83f6bd6097a214f59792a7006c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	local _DATE=$(date -u '+%Y-%m-%d %H:%M UTC')
	go build -v -ldflags "-X \"main.Version=$TERMUX_PKG_VERSION\" -X \"main.BuildTime=$_DATE\"" \
		./cmd/step
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin step
}


termux_step_post_massage() {
	mkdir -p ./share/bash-completion/completions
	mkdir -p ./share/zsh/site-functions
	mkdir -p ./share/fish/vendor_completions.d
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		${TERMUX_PREFIX}/bin/step completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/step
		${TERMUX_PREFIX}/bin/step completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_step
		${TERMUX_PREFIX}/bin/step completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/step.fish
		exit 0
	EOF
	cat <<-EOF > ./prerm
		#!${TERMUX_PREFIX}/bin/sh
		rm -f ${TERMUX_PREFIX}/share/bash-completion/completions/step
		rm -f ${TERMUX_PREFIX}/share/zsh/site-functions/_step
		rm -f ${TERMUX_PREFIX}/share/fish/vendor_completions.d/step.fish
		exit 0
	EOF
}
