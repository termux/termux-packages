TERMUX_PKG_HOMEPAGE=https://github.com/LedgerHQ/btchip-python
TERMUX_PKG_DESCRIPTION="Ledger HW.1 Python API"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.32
TERMUX_PKG_SRCURL="https://github.com/LedgerHQ/btchip-python/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b5cce374072467d27267d5c4a9159e7e956a016543d8a0f00e20c9830061ec9b
# EOL, no need to check for updates
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="python, python-pip, python-hidapi"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="ecdsa"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
