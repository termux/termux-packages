TERMUX_PKG_HOMEPAGE=https://github.com/tLDP/python-tldp
TERMUX_PKG_DESCRIPTION="Tools for publishing from TLDP sources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.5
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/tLDP/python-tldp/archive/refs/tags/tldp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bae313095b877b4272ddccaabd70efcbc526e2c1036f63fb665ec7ce10c94cde
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="networkx, nose"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
