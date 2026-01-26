TERMUX_PKG_HOMEPAGE=https://github.com/letoams/hash-slinger
TERMUX_PKG_DESCRIPTION="Various tools to generate special DNS records"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5"
TERMUX_PKG_SRCURL=https://github.com/letoams/hash-slinger/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5a03bfeba39134773e0a98b1607521b5b70fba58173a20deb7e032cc7e949bcb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ca-certificates, gnupg, openssh, python, pyunbound, resolv-conf, swig, python-pip"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_TARGET_DEPS="dnspython, ipaddr, m2crypto, python-gnupg"

termux_step_make() {
	:
}

termux_step_make_install() {
	local f
	for f in openpgpkey sshfp tlsa; do
		install -Dm700 -t $TERMUX_PREFIX/bin ${f}
		install -Dm600 -t $TERMUX_PREFIX/share/man/man1 ${f}.1
	done
}
