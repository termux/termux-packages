TERMUX_PKG_HOMEPAGE=https://github.com/letoams/hash-slinger
TERMUX_PKG_DESCRIPTION="Various tools to generate special DNS records"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/letoams/hash-slinger/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1b255698ad8b2e5e05a443949476794b3b2a33a8f1e335146cc97a4579964bc1
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

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
