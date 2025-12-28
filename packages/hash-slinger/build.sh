TERMUX_PKG_HOMEPAGE=https://github.com/letoams/hash-slinger
TERMUX_PKG_DESCRIPTION="Various tools to generate special DNS records"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/letoams/hash-slinger/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=46274aa2124c766c2c15c73576f895db7556bf03c7d3e9e4bb917858fae34ffc
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
