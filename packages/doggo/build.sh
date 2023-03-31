TERMUX_PKG_HOMEPAGE=https://github.com/mr-karan/doggo
TERMUX_PKG_DESCRIPTION="A modern command-line DNS client written in Golang and supporting protocols such as DoH, DoT, DoQ and DNSCrypt"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION="0.5.5"
TERMUX_PKG_SRCURL="https://github.com/mr-karan/doggo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7ba1340ce46566ca8fa1565ef261519dee5b1c7007aea97eb1f9329f8a3f0403
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GO_USE_OLDER=true

termux_step_make() {
	termux_setup_golang

	local _builtAt=$(date +'%FT%T%Z')

	local ldflags="\
	-w -s \
	-X 'main.buildVersion=${TERMUX_PKG_VERSION}' \
	-X 'main.buildDate=${_builtAt}' \
	"

	export CGO_ENABLED=1

	go build -o doggo -ldflags="$ldflags" ./cmd/doggo/
	go build -o doggo-api -ldflags="$ldflags" ./cmd/api/

}

termux_step_make_install() {
	install -Dm700 ./doggo ${TERMUX_PREFIX}/bin
	install -Dm700 ./doggo-api ${TERMUX_PREFIX}/bin

	install -Dm644 ./completions/doggo.zsh ${TERMUX_PREFIX}/share/zsh/site-functions/_doggo
	install -Dm644 ./completions/doggo.fish ${TERMUX_PREFIX}/share/fish/vendor_completions.d/doggo.fish
}
