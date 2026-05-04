TERMUX_PKG_HOMEPAGE=https://smallstep.com/cli
TERMUX_PKG_DESCRIPTION="An easy-to-use CLI tool for building, operating, and automating Public Key Infrastructure (PKI) systems and workflows"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.30.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/smallstep/cli/releases/download/v${TERMUX_PKG_VERSION}/step_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=db62a88ebec709de591dd86eec9759e15bdff4c6b96f3d7db6f53b6cf86bd3ec
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="termux-tools"

termux_step_post_get_source() {
	# termux_unpack_src_archive defaults to strip-components=1
	# which works for majority of archives with source code
	# in a subfolder
	# unfortunately this breaks archives with source code at
	# root level
	# manually extract without strip-components
	termux_download_src_archive
	local file="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL}")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR"
}

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
