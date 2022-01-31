TERMUX_PKG_HOMEPAGE=https://electrum.org
TERMUX_PKG_DESCRIPTION="Electrum is a lightweight Bitcoin wallet."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.5
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://download.electrum.org/$TERMUX_PKG_VERSION/Electrum-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6790407e21366186d928c8e653e3ab38476ca86e4797aa4db94dcca2384db41a
TERMUX_PKG_DEPENDS="python, libsecp256k1"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# asciinema previously contained some files that python packages have in common
TERMUX_PKG_CONFLICTS="asciinema (<< 1.4.0-1)"

_PYTHON_VERSION=3.10

TERMUX_PKG_RM_AFTER_INSTALL="
bin/easy_install
bin/qr
bin/chardetect
bin/qdarkstyle
bin/easy_install-${_PYTHON_VERSION}
lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
lib/python${_PYTHON_VERSION}/site-packages/site.py
lib/python${_PYTHON_VERSION}/site-packages/setuptools.pth
lib/python${_PYTHON_VERSION}/site-packages/electrum/gui/qt
lib/python${_PYTHON_VERSION}/site-packages/helpdev-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/attrs-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/PySocks-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/dnspython-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/ecdsa-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/jsonrpclib_pelix-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/pbkdf2-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/protobuf-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/pyaes-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/qrcode-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/aiohttp_socks-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/aiorpcX-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/async_timeout-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/certifi-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/yarl-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/QDarkStyle-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/QtPy-*-py${_PYTHON_VERSION}.egg
lib/python${_PYTHON_VERSION}/site-packages/aiohttp-*-py${_PYTHON_VERSION}-*.egg
lib/python${_PYTHON_VERSION}/site-packages/multidict-*-py${_PYTHON_VERSION}-*.egg
lib/python${_PYTHON_VERSION}/site-packages/protobuf-*-py${_PYTHON_VERSION}-*.egg
"

termux_step_make () {
	return
}

termux_step_make_install () {
	# Force reinstall:
	rm -rf $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/electrum
	rm -rf $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/Electrum-${TERMUX_PKG_VERSION}-py${_PYTHON_VERSION}.egg*
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/
	YARL_NO_EXTENSIONS=1 MULTIDICT_NO_EXTENSIONS=1 \
		CFLAGS=-I$TERMUX_PREFIX/include/python${_PYTHON_VERSION} \
		python${_PYTHON_VERSION} setup.py install --prefix=$TERMUX_PREFIX
}

termux_step_post_massage () {
	find . -path '*/__pycache__*' -delete
	# Other python packages also provides this file. Should be removed from all python packages
	for file in ./lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth ./lib/python${_PYTHON_VERSION}/site-packages/site.py; do
		if [ -f $file ]; then
			rm $file
		fi
	done
}

termux_step_create_debscripts () {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip3 install 'ecdsa>=0.14' 'qrcode' 'protobuf>=3.12' 'dnspython<2.0' 'qdarkstyle<2.9' 'aiorpcx>=0.18,<0.19' 'aiohttp>=3.3.0,<4.0.0' 'aiohttp_socks>=0.3' 'certifi' 'bitstring' 'attrs>=19.2.0' 'pycryptodomex'" >> postinst
}
