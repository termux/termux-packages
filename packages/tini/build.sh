TERMUX_PKG_HOMEPAGE=https://github.com/krallin/tini
TERMUX_PKG_DESCRIPTION="A tiny but valid \`init\` for containers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@yonle <yonle@duck.com>"
TERMUX_PKG_VERSION=0.19.0
TERMUX_PKG_SRCURL=https://github.com/krallin/tini/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0fd35a7030052acd9f58948d1d900fe1e432ee37103c5561554408bdac6bbf0d

termux_step_make() {
	# We can't build tini-static, So build regular binary instead
	ninja tini
}

termux_step_make_install() {
	# Installing it with ninja will build the static binary,
	# So install the binary manually
	install -Dm700 -t $TERMUX_PREFIX/bin ./tini
}
