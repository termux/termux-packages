TERMUX_PKG_HOMEPAGE=https://ohmyposh.dev
TERMUX_PKG_DESCRIPTION="A prompt theme engine for any shell."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="29.35.1"
TERMUX_PKG_SRCURL=https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=36978817d552435627856632f4e1bfcdd13d218512f120f58f2e6c6a77fa0808
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	cd "${TERMUX_PKG_SRCDIR}/src/"

	termux_setup_golang
	go mod tidy
}

termux_step_make() {
	cd "${TERMUX_PKG_SRCDIR}/src/"

	local ldflags=''
	ldflags+="-linkmode=external "
	ldflags+="-X github.com/jandedobbeleer/oh-my-posh/src/build.Version=${TERMUX_PKG_VERSION} "
	ldflags+="-X github.com/jandedobbeleer/oh-my-posh/src/build.Date=$(date +%F)"
	go build -buildvcs=false -ldflags="${ldflags}" -o oh-my-posh
}

termux_step_make_install() {
	cd "${TERMUX_PKG_SRCDIR}/src/"

	install -Dm700 ./oh-my-posh "${TERMUX_PREFIX}/bin/"

	install -d "${TERMUX_PREFIX}/share/oh-my-posh/themes"
	install -m 600 ../themes/* -t "${TERMUX_PREFIX}/share/oh-my-posh/themes"
}
