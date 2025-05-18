TERMUX_PKG_HOMEPAGE=https://ohmyposh.dev
TERMUX_PKG_DESCRIPTION="A prompt theme engine for any shell."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.23.1"
TERMUX_PKG_SRCURL=https://github.com/JanDeDobbeleer/oh-my-posh/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=830e347abfa8a84a979835f624da4eefd8279ce36b43b49ad20189aaa36bb9c9
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
