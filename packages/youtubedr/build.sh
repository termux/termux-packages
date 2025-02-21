TERMUX_PKG_HOMEPAGE=https://github.com/kkdai/youtube
TERMUX_PKG_DESCRIPTION="Download youtube video in Golang"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="2.10.3"
TERMUX_PKG_SRCURL=https://github.com/kkdai/youtube/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=697ca27f894efdd3f1249b46d7e587a3d1348158e130c5c1307ce32d505c6d01
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"
	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/kkdai/"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/kkdai/youtube"
	cd "${GOPATH}/src/github.com/kkdai/youtube/"
	go get -d -v
	cd cmd/youtubedr
	go build .
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/kkdai/youtube/cmd/youtubedr/youtubedr

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/youtubedr
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_youtubedr
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/youtubedr.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		youtubedr completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/youtubedr
		youtubedr completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_youtubedr
		youtubedr completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/youtubedr.fish
	EOF
}
