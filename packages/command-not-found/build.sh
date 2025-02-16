TERMUX_PKG_HOMEPAGE=https://github.com/termux/command-not-found
TERMUX_PKG_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_REVISION=63
TERMUX_PKG_SRCURL=https://github.com/termux/command-not-found/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4b7d3684437a33c343a31db00116a3170d24f0cfeebe1f75951b785cf5736aac
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	export TERMUX_PREFIX
	export TERMUX_PKG_CACHEDIR
	termux_setup_nodejs

	termux_download https://github.com/termux/termux-packages/raw/master/repo.json \
		$TERMUX_PKG_CACHEDIR/repo.json SKIP_CHECKSUM
}
