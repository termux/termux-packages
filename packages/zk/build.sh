TERMUX_PKG_HOMEPAGE=https://zk-org.github.io/zk/
TERMUX_PKG_DESCRIPTION="A plain text note-taking assistant"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@kirasok"
TERMUX_PKG_VERSION="0.15.4"
TERMUX_PKG_SRCURL=https://github.com/zk-org/zk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=024b5a1615c8ac1924ec3338b36031c36131bad5de77dcce05adce35659b7489
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
VERSION=$TERMUX_PKG_VERSION
BUILD=
"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin zk
}
