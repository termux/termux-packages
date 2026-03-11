TERMUX_PKG_HOMEPAGE=https://github.com/simplex-chat/simplexmq
TERMUX_PKG_DESCRIPTION="SimpleX Messaging Protocol"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="6.4.4"
TERMUX_PKG_SRCURL="https://github.com/simplex-chat/simplexmq/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b3643ade5a4dd2dbf78f19ce662c23ad8083397dabcdfbfe277d97ef30a340fb
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	trap 'cat /home/builder/.ghcup/logs' EXIT
	export BOOTSTRAP_HASKELL_GHC_VERSION=9.6.3
	export BOOTSTRAP_HASKELL_CABAL_VERSION=3.10.3.0
	curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh
	ghcup set ghc "${BOOTSTRAP_HASKELL_GHC_VERSION}"
	ghcup set cabal "${BOOTSTRAP_HASKELL_CABAL_VERSION}"
	source ~/.ghcup/env
	cabal update
	cabal build exe:"${TERMUX_PKG_NAME}"
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/bin"
}
