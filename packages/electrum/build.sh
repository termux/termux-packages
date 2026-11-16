TERMUX_PKG_HOMEPAGE=https://electrum.org
TERMUX_PKG_DESCRIPTION="Electrum is a lightweight Bitcoin wallet"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.8.4"
TERMUX_PKG_SRCURL="https://download.electrum.org/$TERMUX_PKG_VERSION/Electrum-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b3cbeefe37e84f62f6cec096eec28085d7a99097841eb96c9ee3e9bec20b0367
# The python dependency list should be compared to
# contrib/requirements/requirements.txt in upstream project on every
# update (or at least every major update).
# https://github.com/spesmilo/electrum/blob/master/contrib/requirements/requirements.txt
# Disable auto updates for now.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="python, libsecp256k1, python-pip, python-cryptography"
TERMUX_PKG_PYTHON_TARGET_DEPS="'qrcode', 'protobuf>=3.20', 'qdarkstyle>=3.2', 'aiorpcx>=0.25.0,<0.26', 'aiohttp>=3.11.0,<4.0.0', 'aiohttp_socks>=0.9.2', 'certifi>=2026.10.19', 'jsonpatch', 'electrum_ecc>=0.0.4,<0.1', 'electrum_aionostr>=0.1.0,<0.2', 'dnspython>=2.3,<2.5'"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# asciinema previously contained some files that python packages have in common
TERMUX_PKG_CONFLICTS="asciinema (<< 1.4.0-1)"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_SERVICE_SCRIPT=("electrum" 'exec electrum daemon 2>&1')

termux_step_create_debscripts() {
	cat > postinst <<-EOF
		#!${TERMUX_PREFIX}/bin/sh
		export ELECTRUM_ECC_DONT_COMPILE=1
	EOF
	chmod 0755 postinst
}
