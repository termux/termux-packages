TERMUX_PKG_HOMEPAGE=https://electrum.org
TERMUX_PKG_DESCRIPTION="Electrum is a lightweight Bitcoin wallet"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.5.8"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.electrum.org/$TERMUX_PKG_VERSION/Electrum-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=dd8595a138132dee87cee76ce760a1d622fc2fd65d3b6ac7df7e53b7fb6ea7e8
# The python dependency list should be compared to
# contrib/requirements/requirements.txt in upstream project on every
# update (or at least every major update).  Disable auto updates for
# now.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="python, libsecp256k1, python-pip, python-cryptography"
TERMUX_PKG_PYTHON_TARGET_DEPS="'qrcode', 'protobuf<4,>=3.20', 'qdarkstyle>=2.7', 'aiorpcx<0.24,>=0.22.0', 'aiohttp<4.0.0,>=3.3.0', 'aiohttp_socks>=0.8.4', 'certifi', 'attrs>=20.1.0', 'jsonpatch', 'dnspython>=2.0'"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# asciinema previously contained some files that python packages have in common
TERMUX_PKG_CONFLICTS="asciinema (<< 1.4.0-1)"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_SERVICE_SCRIPT=("electrum" 'exec electrum daemon 2>&1')

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
