TERMUX_PKG_HOMEPAGE=https://ohmyposh.dev
TERMUX_PKG_DESCRIPTION="A prompt theme engine for any shell."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.10.2"
TERMUX_PKG_SRCURL=https://github.com/JanDeDobbeleer/oh-my-posh/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b9a9b5c028cd2627e23b5bdffd225db9d843c5d72cc11892e5e250149e4719a8
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init oh-my-posh
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
