TERMUX_PKG_HOMEPAGE=https://github.com/letoams/hash-slinger
TERMUX_PKG_DESCRIPTION="Various tools to generate special DNS records"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/letoams/hash-slinger/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e57ba0ae4089b70f4a6fc8ac1edbbd4dd629ad8f8bcff1ff50408a137e170ad9
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
